 extends Node

var wheel = null
var active = null
var player = null
var enemies = []
var items = []
var summed_experience = 0
var summed_currency = 0
var enemyclass = preload("res://Objects/Characters/Enemy.gd")
enum States {
	PROCESSING, TURN, WAIT
}
var state = States.PROCESSING
signal combat_over


func _init():
	enemies = Globals.enemies
	if not enemies or enemies.size() <= 0:
		for i in 3:
			enemies.append(preload("res://Objects/Characters/Enemy.tscn").instance())
	

func _ready():
	Globals.play_bgm(load("res://BGM/Fight/" + Globals.get_random_from_folder("res://BGM/Fight/")))
	var path = "res://Graphics/backgrounds/" + Globals.currenttheme + "/"
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".import"):
			file = file.replace(".import", "")
			files.append(file)
	while not $Background.texture and files.size() > 0:
		$Background.texture = load(path + files[randi()%files.size()])
	
	
	player = Globals.player
	add_child(player)
	player.global_position = Vector2(200,300)
	player.connect("attacking", self, "_attack_screenshake")
	active = player
	var t = 0
	for enemy in enemies:
		enemy.connect("death", self, "_on_Enemy_death")
		enemy.connect("mouse_entered", self, "_on_Enemy_mouse_entered")
		enemy.get_node("HPArea").connect("input_event", self, "_on_Enemy_mouse_input",[enemy])
		enemy.connect("mouse_left", self, "_on_Enemy_mouse_left")
		enemy.connect("attacking", self, "_attack_screenshake")
		add_child(enemy)
		enemy.scale.x = -1
		enemy.global_position = Vector2(800,160 + t)
		t += 500 / enemies.size()
#warning-ignore:return_value_discarded
	$Timer.connect("timeout", self, "_cont")
	player.set_bars()

func _attack_screenshake(user, enemy, damage):
	var amount = (float(damage)/enemy.maxhitpoints) * 10 + 1
	_screen_shake(amount)

func _screen_shake(amount : int = 1):
	$Camera2D.offset = Vector2(amount,amount)

func _cont():
	state = States.PROCESSING

func get_next_round():
	if player.hitpoints < 0: return
	for enemy in enemies:
		if not is_instance_valid(enemy) or not enemy is enemyclass or enemy.hitpoints <= 0:
			enemies.erase(enemy)
			continue
		enemy.initiative += enemy.speed
	player.initiative += player.speed
	var highest = player
	for enemy in enemies:
		if enemy.initiative > highest.initiative:
			highest = enemy
	highest.initiative = 0
	active = highest

#warning-ignore:unused_argument
func _process(delta):
	if ($Camera2D.offset.x != 0 or $Camera2D.offset.y != 0):
		if abs($Camera2D.offset.x) < 0.01:
			$Camera2D.offset.x = 0
		else:
			$Camera2D.offset.x *= -0.6
		if abs($Camera2D.offset.y) < 0.01:
			$Camera2D.offset.y = 0
		else:
			$Camera2D.offset.y *= -0.6
	match(state):
		States.PROCESSING:
			if not active:
				get_next_round()
			else:
				state = States.TURN
		States.TURN:
			if active is enemyclass:
				active.take_action(player)
				active = null
				state = States.WAIT
				$Timer.start()
	if enemies.size() <= 0 and $Timer.is_connected("timeout", self, "_cont"):
		var overlay = Globals.get_overlay()
		if overlay:
			var rewards = preload("res://Objects/Misc/DialogBox.tscn").instance()
			rewards.add_text("You won!")
			rewards.add_text(str("You gained ", summed_experience, " experience!"))
			rewards.add_text(str("You found ", summed_currency, " jewels!"))
			if items:
				rewards.add_text("Items found:")
				for item in items:
					rewards.add_text(item.name)
					player.add_item(item)
			rewards.connect("ok_pressed", self, "_won")
			overlay.add_child(rewards)
			rewards.rect_global_position = Vector2(400,150)
			$Timer.disconnect("timeout", self, "_cont")
		

func _won():
	emit_signal("combat_over")
	for s in player.status:
		s.remove()
	player.status.clear()
	player.get_node("ItemList").clear()
	Globals.player = player
	remove_child(player)
	if Globals.boss_fight:
		Globals.boss_fight = false
		var overlay = Globals.get_overlay()
		if overlay:
			var game_won = preload("res://Objects/Misc/DialogBox.tscn").instance()
			game_won.add_text("You've beat the darkness!")
			game_won.connect("ok_pressed", Transition, "fade_to", ["res://GameWon.tscn"])
			overlay.add_child(game_won)
			game_won.rect_global_position = Vector2(400,150)
			game_won.visble = true
	else:
		Transition.fade_to("res://TextMap.tscn")

func _on_Enemy_mouse_entered(enemy):
	if enemy.hitpoints < 0:
		return
	if active != player:
		if is_instance_valid(wheel):
			wheel.call_deferred("free")
		return
	if wheel:
		if is_instance_valid(wheel):
			wheel.call_deferred("free")
	wheel = preload("res://Objects/SkillWheel.tscn").instance()
	wheel.global_position = enemy.global_position
	wheel.skills = player.skills
	wheel.player = player
	wheel.enemy = enemy
	wheel.controller = self
	add_child(wheel)
	wheel.initialize()

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_action_pressed(player, enemy, skill):
	if player.skillpoints < skill.cost:
		return
	active = null
	state = States.WAIT
	$Timer.start()
	wheel.call_deferred("free")
	player.on_round_start()

#warning-ignore:unused_argument
func _on_Enemy_mouse_left(enemy):
	if is_instance_valid(wheel):
		wheel.call_deferred("free")

func _on_Enemy_death(enemy):
	enemies.erase(enemy)
	var currency_worth = int(enemy.level * 1.5)
	Globals.currency += currency_worth
	summed_currency += currency_worth
	var exp_worth = enemy.level
	player.gain(exp_worth)
	summed_experience += exp_worth
	for item in enemy.loot:
		items.append(item)
	if is_instance_valid(wheel):
		wheel.call_deferred("free")

func _on_Enemy_mouse_input(viewport, event, shape, enemy):
	if wheel:
		if is_instance_valid(wheel):
			return
	_on_Enemy_mouse_entered(enemy)
