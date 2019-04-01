extends "res://Objects/Character.gd"

signal mouse_entered(enemy)
signal mouse_left(enemy)
signal mouse_input(enemy)

var loot = []

func _ready():
	$HealthBar.rect_scale.x *= -1
	$SkillBar.rect_scale.x *= -1
	$HealthBar.rect_position.x *= -1
	$SkillBar.rect_position.x *= -1

func generate_w_image(lvl : int, image : Texture = null):
	$Sprite.texture = image
	vitality = 7 + randi()%3
	strength = 9 + randi()%3
	intelligence = 7 + randi()%3
	speed = 7+ randi()%3
	maxhitpoints = 25 + randi()%10
	hitpoints = maxhitpoints
	maxskillpoints = 20
	skillpoints = maxskillpoints
	for i in lvl - 1:
		level_up()
		vitality += 1
		strength += 1
		intelligence += 1
		speed += 1

func generate(lvl : int, theme : String):
	generate_w_image(lvl, Globals.get_monster_image_by_theme(theme))


func take_action(target):
	on_round_start()
	if skills.size() <= 0:
		attack(self, target)
	else:
		var skill = skills[randi()%skills.size()]
		if skillpoints >= skill.cost:
			skill.user = self
			skill.enemy = target
			skill.exec()
		else:
			attack(self, target)

func _on_Area2D_mouse_entered():
	._on_Area2D_mouse_entered()
	emit_signal("mouse_entered", self)

func _on_Area2D_mouse_exited():
	._on_Area2D_mouse_exited()
	emit_signal("mouse_left", self)


func _on_Area2D_input_event(viewport, event, shape_idx):
	emit_signal("mouse_input", self)