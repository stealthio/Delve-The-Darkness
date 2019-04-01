extends Node2D

export (int) var maxhitpoints = 100
export (int) var hitpoints = 100
export (int) var maxskillpoints = 100
export (int) var skillpoints = 100
export (int) var vitality = 10
export (int) var strength = 10
export (int) var intelligence = 10
export (int) var speed = 10
export (int) var level = 1
export (float) var armor = 0.0
export (float) var lifesteal = 0.0
var initiative = 0
var c = load("res://Objects/Character.gd")
var playback : AnimationNodeStateMachinePlayback
var skills = [Globals.skills["attack"]]
var status = []
signal attacking(user, target, damage)
signal attacked(attacker, damage)
signal attack_ended()
signal death(who)

func level_up():
	level += 1
	maxhitpoints += level + int(vitality) + int(strength/2)
	hitpoints = maxhitpoints
	maxskillpoints += level + intelligence
	skillpoints = maxskillpoints
	vitality+= randi()%2
	strength+= randi()%2
	intelligence+= randi()%2
	speed+= randi()%2

func _play_attacked_animation(whom, amount):
	add_child(load("res://Objects/Effects/Slash/Slash.tscn").instance())

func attack(user, character):
	assert(character is c)
	playback.travel("attack")
	var damage = strength
	emit_signal("attacking",self ,character, damage)
	character.hitpoints -= damage
	character.emit_signal("attacked", self, damage)
	if (hitpoints > maxhitpoints): hitpoints = maxhitpoints
	if (skillpoints > maxskillpoints): skillpoints = maxskillpoints
	if (skillpoints < 0): skillpoints = 0
	set_bars()

func on_round_start():
	skillpoints += int(maxskillpoints/20)
	if (hitpoints > maxhitpoints): hitpoints = maxhitpoints
	if (skillpoints > maxskillpoints): skillpoints = maxskillpoints
	if (skillpoints < 0): skillpoints = 0
	for s in status:
		s.par = self
		s.exec()
		if s.duration <= 0:
			s.remove()
			status.erase(s)
	set_bars()

func on_attacked(whom, damage):
	Globals.play_sound(load("res://SFX/attack/" + Globals.get_random_from_folder("res://SFX/attack/")))
	var reduction = 0
	if armor > 0:
		reduction = (damage * armor)
		if reduction > damage * 0.9:
			reduction = int(damage * 0.9)
	hitpoints += reduction
	damage = int(damage-reduction)
	var scrolltext = preload("res://Objects/Misc/Scrolltext.tscn").instance()
	scrolltext.create(str(damage), Vector2(global_position.x-16,global_position.y-32))
	get_parent().add_child(scrolltext)
	check_death()
	if (hitpoints > maxhitpoints): hitpoints = maxhitpoints
	if (skillpoints > maxskillpoints): skillpoints = maxskillpoints
	if (skillpoints < 0): skillpoints = 0
	set_bars()

func check_death():
	if hitpoints <= 0:
		emit_signal("death", self)
		$Sprite.modulate = Color(1,0,0)

func set_bars():
	$HealthBar.max_value = maxhitpoints
	$HealthBar.value = hitpoints
	if hitpoints > 0:
		$HealthBar.tint_progress = Color(2.0-(float(hitpoints)/maxhitpoints),1,1)
	$SkillBar.max_value = maxskillpoints
	$SkillBar.value = skillpoints
	$ItemList.clear()
	for s in status:
		$ItemList.add_icon_item(s.icon)
	$HealthBar/Label.text = str(hitpoints,"/",maxhitpoints)
	$SkillBar/Label.text = str(skillpoints,"/",maxskillpoints)

func _ready():
	connect("attacked", self, "on_attacked")
	connect("attacked", self, "_play_attacked_animation")
	connect("attacking", self, "_calculate_lifesteal")
	playback = $AnimationTree.get("parameters/playback")
	playback.start("idle")
	$AnimationTree.active = true
	set_bars()

func _calculate_lifesteal(who, whom, amount):
	if lifesteal == 0.0: return
	if lifesteal < 0.0:
		lifesteal = 0.0
		return
	var heal = int(amount * lifesteal)
	hitpoints += heal
	if hitpoints > maxhitpoints:
		hitpoints = maxhitpoints

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		emit_signal("attack_ended")
	set_bars()
	

func _on_Area2D_mouse_entered():
	$HealthBar/Label.visible = true
	$HealthBar/Label.text = str(hitpoints,"/",maxhitpoints)
	$SkillBar/Label.visible = true
	$SkillBar/Label.text = str(skillpoints,"/",maxskillpoints)

func _on_Area2D_mouse_exited():
	$HealthBar/Label.visible = false
	$SkillBar/Label.visible = false
