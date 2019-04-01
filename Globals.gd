extends Node

var c = load("res://Objects/Character.gd")
var s = preload("res://Skill.gd")
var player_class = preload("res://Objects/Characters/Player.gd")
var e = preload("res://Status.gd")
var itempath = preload("res://Item.gd")
var player = null
var enemies = []
var darkness_threshold = 100
var darkness = 1  # if reaches threshhold -> player ded
var darknessinc = 1# increases the longer you stay at stage
var darknessres = 1
var depth = 1
var currency = 0
var themes = ["common","dwarven","moist","rocky","undead"]
var currenttheme = themes[0]
var map = null
var player_coordinates = null
var shops = []
var currshop = null
var finished = false
var boss_fight = false
signal game_over
signal darkness_increased(amount)
signal went_deeper()

#SKILLS
var skills = {
	# GENERAL
	attack = s.new("Attack", load("res://Graphics/Skills/SpellBook01_14.png"), funcref(self, "skill_attack"), 0, "A basic attack, damage scales with your primary attribute"),
	
	# WARRIOR
	bash = s.new("Bash", load("res://Graphics/Skills/SpellBook01_38.png"), funcref(self, "skill_bash"), 25, "Bash your enemies skull, does damage equal to [color=red]140% of your strength[/color]"),
	bleed = s.new("Bleed", load("res://Graphics/Skills/SpellBook01_76.png"), funcref(self, "skill_bleed"), 28, "Cut heavy wounds into your enemy, does damage equal to [color=red]80% of your strength[/color] and [color=white]8% of the enemies max-hp[/color] for 3 rounds"),
	bloodthirst = s.new("Bloodthirst", load("res://Graphics/Skills/SpellBook01_80.png"), funcref(self, "skill_bloodthirst"), 15, "You're thirsting for blood, you heal for 40% of any damage done for 4 rounds"),
	berserk = s.new("Berserk", load("res://Graphics/Skills/SpellBook01_30.png"), funcref(self, "skill_berserk"), 15, "You're going in berserking stance, for three rounds your attacks are executed twice"),
	sacrifice = s.new("Sacrifice", load("res://Graphics/Skills/SpellBook01_28.png"), funcref(self, "skill_sacrifice"), 10, "You hurt yourself to inflict more damage to your enemy. Use 10% of your max-HP to deal damage equal to the used HP * 2 + your level"),
	cleave = s.new("Cleave", load("res://Graphics/Skills/SpellBook01_15.png"), funcref(self, "skill_cleave"), 30, "You hit every enemy for [color=red]80% of your strength[/color]"),
	
	# WIZARD
	fireball = s.new("Fireball", load("res://Graphics/Skills/SpellBook01_17.png"), funcref(self, "skill_fireball"), 25, "Throw a fireball at your enemies. Does damage equal to [color=blue]140% of your intelligence[/color]"),
	heal_weak = s.new("Weak Heal", load("res://Graphics/Skills/SpellBook01_04.png"), funcref(self, "skill_heal_weak"), 25, "Heals you for [color=white]10[/color] + your level HP"),
	burn = s.new("Burn", load("res://Graphics/Skills/SpellBook01_26.png"), funcref(self, "skill_burn"), 25, "Ignite the enemy to cause [color=blue]60% of your intelligence[/color] as damage for 5 rounds"),
	renuvation = s.new("Renuvation", load("res://Graphics/Skills/SpellBook01_05.png"), funcref(self, "skill_renuvation"), 25, "Heals you for a small amount, scales with your [color=blue]level[/color]"),
	
	# ROGUE
	stab = s.new("Stab", load("res://Graphics/Skills/SpellBook01_68.png"), funcref(self, "skill_stab"), 25, "Quickly stabs the enemy. Does damage equal to [color=green]140% of your speed[/color]"),
	poison_weapon = s.new("Poison Weapon", load("res://Graphics/Skills/SpellBook01_75.png"), funcref(self, "skill_poison_weapon"), 30, "Your attacks apply a poison which deals damage over 3 rounds. Poison is active for 4 rounds"),
	triple_attack = s.new("Triple Attack", load("res://Graphics/Skills/SpellBook01_25.png"), funcref(self, "skill_triple_attack"), 28, "Stab your enemy 3 times in succession for [color=green]50% of your speed each[/color]"),
}
var s_kill = s.new("Kill", load("res://Graphics/Skills/SpellBook01_06.png"), funcref(self, "skill_kill"),1,"Does flat [color=white]1000[/color] damage, actually just for testing purposes")

func skill_berserk(user,enemy):
	play_sound(preload("res://SFX/More Woosh2.wav"))
	user.status.append(status.berserk.duplicate())

func skill_triple_attack(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.speed * 0.5)
	user.playback.travel("attack")
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	

func skill_poison_weapon(user, enemy):
	play_sound(preload("res://SFX/More Woosh2.wav"))
	user.status.append(status.poison_weapon.duplicate())
	
func skill_stab(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.speed * 1.4)
	user.playback.travel("attack")
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)

func skill_burn(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.intelligence * 0.6)
	user.playback.travel("attack")
	user.emit_signal("attacking",user,  enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	var st = status.burn.duplicate()
	st.value = int(user.intelligence * 0.6)
	enemy.status.append(st)

func skill_cleave(user, enemy):
	assert(user is c)
	assert(enemy is c)
	user.playback.travel("attack")
	var damage = int(user.strength * 0.8)
	if user is player_class:
		for en in enemies:
			user.emit_signal("attacking",user, en, damage)
			en.hitpoints -= damage
			en.emit_signal("attacked", user, damage)
	else:
		user.emit_signal("attacking",user, enemy, damage)
		enemy.hitpoints -= damage
		enemy.emit_signal("attacked", user, damage)

func skill_fireball(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.intelligence * 1.4)
	user.playback.travel("attack")
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)

func skill_sacrifice(user,enemy):
	var selfdamage = int(user.maxhitpoints * 0.1)
	var damage = selfdamage * 2 + user.level
	user.hitpoints -= selfdamage
	user.emit_signal("attacked", user, selfdamage)
	user.playback.travel("attack")
	user.emit_signal("attacking",user,  enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	

func go_deeper():
	depth += 1
	darknessinc += 1
	currenttheme = themes[randi()%themes.size()]
	emit_signal("went_deeper")
	#emit_signal("darkness_increased", darknessinc)
	#if darkness > darkness_threshold:
	#	game_over(self)

func inc_darkness():
	darkness += darknessinc
	emit_signal("darkness_increased", darknessinc)
	if darkness > darkness_threshold:
		game_over(self)

func skill_bloodthirst(user,enemy):
	play_sound(preload("res://SFX/More Woosh2.wav"))
	user.status.append(status.lifesteal.duplicate())

func skill_cripple(user,enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.strength * 0.75)
	user.playback.travel("attack")
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	enemy.status.append(status.cripple.duplicate())

func skill_bleed(user,enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.strength * 0.8)
	user.playback.travel("attack")
	user.emit_signal("attacking",user,  enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)
	enemy.status.append(status.bleed.duplicate())

func skill_renuvation(user,enemy):
	play_sound(preload("res://SFX/Heal.wav"))
	user.status.append(status.regeneration.duplicate())

func skill_bash(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = int(user.strength * 1.4)
	user.playback.travel("attack")
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)

func skill_attack(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = 0
	if (user is player_class):
		var temp : int = user.profession
		match(temp):
			0:
				damage = user.strength
			1:
				damage = user.strength
			2:
				damage = user.intelligence
			3:
				damage = user.speed
	else:
		damage = user.strength
	damage = int(damage)
	user.playback.travel("attack")
	user.emit_signal("attacking",user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", enemy, damage)


func skill_heal_weak(user, enemy):
	assert(user is c)
	play_sound(preload("res://SFX/Heal.wav"))
	enemy = user
	var damage = -10 + user.level
	user.emit_signal("attacking", enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)

func skill_kill(user, enemy):
	assert(user is c)
	assert(enemy is c)
	var damage = 1000
	user.playback.travel("attack")
	user.emit_signal("attacking", user, enemy, damage)
	enemy.hitpoints -= damage
	enemy.emit_signal("attacked", user, damage)

#STATUS
var status = {
	regeneration = e.new("Regeneration", load("res://Graphics/Skills/SpellBook01_05.png"), funcref(self, "status_regenerate"), 4),
	bleed = e.new("Bleed", load("res://Graphics/Skills/SpellBook01_76.png"), funcref(self, "status_bleed"), 3),
	burn = e.new("Burn", load("res://Graphics/Skills/SpellBook01_26.png"), funcref(self, "status_burn"), 5, "",null, 1),
	#cripple = e.new("Cripple", load("res://Graphics/Skills/SpellBook01_67.png"), funcref(self, "status_cripple"), 2, "", funcref(self, "status_remove_cripple")),
	lifesteal = e.new("Lifesteal", load("res://Graphics/Skills/SpellBook01_80.png"), funcref(self, "status_lifesteal"), 4, "", funcref(self, "status_remove_lifesteal")),
	poison_weapon = e.new("Poison Weapon", load("res://Graphics/Skills/SpellBook01_75.png"), funcref(self, "status_poison_weapon"), 4, "", funcref(self, "status_remove_poison_weapon")),
	poison = e.new("Poison", load("res://Graphics/Skills/SpellBook01_86.png"), funcref(self, "status_poison"), 3),
	berserk = e.new("Berserk", load("res://Graphics/Skills/SpellBook01_30.png"), funcref(self, "status_berserk"), 3, "", funcref(self, "status_remove_berserk")),
}

func status_berserk(u, skill):
	if not u.is_connected("attacking", self, "berserk"):
		u.connect("attacking", self, "berserk")

func status_remove_berserk(u, skill):
	u.disconnect("attacking", self, "berserk")

func berserk(user, target, damage):
	user.disconnect("attacking", self, "berserk")
	user.emit_signal("attacking",user, target, damage)
	target.hitpoints -= damage
	target.emit_signal("attacked", user, damage)
	user.connect("attacking", self, "berserk")

func status_poison_weapon(u, skill):
	if not u.is_connected("attacking", self, "apply_poison"):
		u.connect("attacking", self, "apply_poison",[skill])

func status_remove_poison_weapon(u, skill):
	u.disconnect("attacking", self, "apply_poison")

func apply_poison(user, target, damage, skill):
	target.status.append(status.poison.duplicate())

func status_poison(u, skill):
	var damage = ceil(u.hitpoints/10.0)
	u.hitpoints -= damage
	u.emit_signal("attacked", u, damage)

func status_burn(u, skill):
	var damage = skill.value
	u.hitpoints -= damage
	u.emit_signal("attacked", u, damage)

func status_lifesteal(u, skill):
	u.lifesteal += 0.4

func status_remove_lifesteal(u, skill):
	u.lifesteal -= 0.4

func status_cripple(u, skill):
	var original_speed = u.get_meta("speed")
	var cripple_count = u.get_meta("cripples")
	if not original_speed:
		original_speed = u.speed
		u.set_meta("speed", original_speed)
	if not cripple_count:
		u.set_meta("cripples", 1)
	else:
		u.set_meta("cripples", u.get_meta("cripples")+1)
	var amount = u.level + 3
	u.speed -= amount
	if u.speed <= 0: u.speed = 1
	
func status_remove_cripple(u, skill):
	u.set_meta("cripples", u.get_meta("cripples") - 1)
	var cripple_count = u.get_meta("cripples")
	if cripple_count <= 0:
		u.speed = u.get_meta("speed")
		u.set_meta("speed", null)

func status_bleed(u, skill):
	var damage = int(u.maxhitpoints/8)
	u.hitpoints -= damage
	u.emit_signal("attacked", u, damage)

func status_regenerate(u, skill):
	u.hitpoints += u.level
	if u.hitpoints > u.maxhitpoints:
		u.hitpoints = u.maxhitpoints

# ITEMS
var items = {
	potion_health = itempath.new("Health Potion", load("res://Graphics/Icons/NecromancerIcons_59_b.png"), funcref(self, "potion_health"), 20, "Permanently increases your maximum HP"),
	potion_healing = itempath.new("Healing Potion", load("res://Graphics/Icons/potions/t_04.png"), funcref(self, "potion_healing"), 20, "Fully restores your HP"),
	potion_strength = itempath.new("Strength Potion", load("res://Graphics/Icons/NecromancerIcons_96_b.png"), funcref(self, "potion_strength"), 20, "Permanently increases your strength"),
	potion_intelligence = itempath.new("Intelligence Potion", load("res://Graphics/Icons/potions/t_21.png"), funcref(self, "potion_intelligence"), 20, "Permanently increases your intelligence"),
	potion_speed = itempath.new("Speed Potion", load("res://Graphics/Icons/NecromancerIcons_97_b.png"), funcref(self, "potion_speed"), 20, "Permanently increases your speed"),
	lantern = itempath.new("Lantern", load("res://Graphics/Icons/MiningIcons_81_b.png"), funcref(self, "darkness_resistance"), 30, "Gives you resistance to the darkness", false),
	torch = itempath.new("Torch", load("res://Graphics/Icons/MiningIcons_75_b.png"), funcref(self, "darkness_resistance"), 30, "Gives you resistance to the darkness", false),
	ghostly_armor = itempath.new("Ghostly Armor", load("res://Graphics/Icons/NecromancerIcons_10_b.png"), funcref(self, "ghostly_armor"), 50, "An armor with a fabric from a different reality - reduces incoming damage", false),
	vampiric_ring = itempath.new("Vampiric Ring", load("res://Graphics/Icons/NecromancerIcons_13_b.png"), funcref(self, "vampiric_ring"), 50, "A ring that lets you suck the life out of your enemies", false),
	plot_note_00 = itempath.new("Diary", load("res://Graphics/Icons/Tex_badge_35.png"), null, 0, "[color=navy]2 weeks ago[/color]\nI wonder if there is any truth behind the myths about the 'dungeon of darkness'. I don't think so but... whatever", false, false),
}

func vampiric_ring(user):
	user.lifesteal += 0.1

func darkness_resistance(user):
	if not self.is_connected("darkness_increased", self, "reduce_darkness"):
		self.connect("darkness_increased", self, "reduce_darkness")
	else:
		darknessres += 1

func ghostly_armor(user):
	user.armor += 0.1

func reduce_darkness(last_increase):
	if darknessres >= last_increase:
		darkness -= last_increase
		return
	darkness -= darknessres

func potion_healing(user):
	user.hitpoints = user.maxhitpoints

func potion_health(user):
	user.maxhitpoints += 10

func potion_speed(user):
	user.speed += 3

func potion_strength(user):
	user.strength += 3

func potion_intelligence(user):
	user.intelligence += 3

func create_enemy(level : int, ski = [], image : Texture = null, badge : Texture = null, loot = []):
	if not image:
		image = get_monster_image_by_theme(currenttheme)
	var enemy = preload("res://Objects/Characters/Enemy.tscn").instance()
	enemy.generate_w_image(level, image)
	enemy.get_node("Badge").texture = badge
	enemy.loot = loot
	for sk in ski:
		enemy.skills.append(sk)
	return enemy

func prepare_boss(level : int, loot = []):
	enemies.clear()
	var sk = []
	for i in int(level/2):
		sk.append(random_from_dic(skills))
	enemies.append(create_enemy(level))
	enemies.append(create_enemy(level + randi()%2+1, sk, get_monster_image_by_theme(currenttheme), load("res://Graphics/Icons/fantasybadges/Tex_badge_04.png"), loot))
	enemies.append(create_enemy(level))

func prepare_final_boss():
	boss_fight = true
	enemies.clear()
	var sk = player.skills
	var e = create_enemy(player.level + 3, sk, player.get_node("Sprite").texture, load("res://Graphics/Icons/fantasybadges/Tex_badge_27.png")) 
	e.armor = player.armor
	e.get_node("Sprite").modulate = Color(0.7,0.7,0.7)
	enemies.append(e)

func prepare_enemies(amount :int , level: int, loot = []):
	enemies.clear()
	for i in amount:
		if randi()%3 == 0:
			enemies.append(create_enemy(level, [random_from_dic(skills)], null, null, loot))
		else:
			enemies.append(create_enemy(level, [], null, null, loot))
		loot.clear()

func get_random_from_folder(path : String):
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
	if files.size() <= 0: return null
	return files[randi()%files.size()]

func get_monster_image_by_theme(theme : String):
	var path = "res://Graphics/Monsters/" + theme + "/"
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
	var tex = null
	if files.size() <= 0: return null
	while not tex:
		tex = load(path + files[randi()%files.size()])
	return tex
	
func restore_character(character):
	assert(character is c)
	character.hitpoints = character.maxhitpoints
	character.skillpoints = character.maxskillpoints

func random_from_dic(dic):
	var list = []
	for element in dic:
		list.append(dic[element])
	if list.size() <= 0: return []
	return list[randi()%list.size()]

func hello_world():
	print("Hello World")

func game_over(from):
	emit_signal("game_over")
	play_sound(preload("res://SFX/Delving.wav"))
	var dir = Directory.new()
	dir.remove("user://data.sav")
	var game_over_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
	get_tree().get_root().add_child(game_over_dialog)
	game_over_dialog.pop("You are defeated, the darkness won.",
				[["Restart", [[self, "restart_game", []],[game_over_dialog, "queue_free",[]]]]],
				load("res://Graphics/Skills/SpellBook01_89.png"))
	for node in get_tree().get_nodes_in_group("delete_on_game_over"):
		node.queue_free()
	

func add_currency(amount):
	currency += amount

func restart_game():
	Globals.currency = 0
	
	player = null
	enemies = []
	darkness_threshold = 100
	darkness = 1
	darknessinc = 1
	depth = 1
	currency = 0
	map = null
	player_coordinates = null
	themes = ["common","dwarven","moist","rocky","undead"]
	currenttheme = themes[0]
	Transition.fade_to("res://ClassSelect.tscn")

func load_game():
	var file = File.new()
	if not file.file_exists("user://data.sav"):
		print("No savegame found")
		return false
	if file.open("user://data.sav", File.READ) != 0:
		print("Couldn't open savegame")
		return false
	var data = JSON.parse(file.get_line())
	if typeof(data.result) != TYPE_DICTIONARY:
		print("Unexpected file while loading data")
		return false
	data = data.result
	player = preload("res://Objects/Characters/Player.tscn").instance()
	player.maxhitpoints = data.player.maxhitpoints
	player.hitpoints = data.player.hitpoints
	player.maxskillpoints = data.player.maxskillpoints
	player.skillpoints = data.player.skillpoints
	player.vitality = data.player.vitality
	player.strength = data.player.strength
	player.intelligence = data.player.intelligence
	player.speed = data.player.speed
	player.level = data.player.level
	player.experience = data.player.experience
	player.maxexperience = data.player.maxexperience
	player.statpoints = data.player.statpoints
	player.profession = data.player.profession
	for item in data.items:
		player.add_item(Globals.items[item])
	currency = data.money
	finished = data.done
	player.gain_skills()
	get_tree().change_scene("res://CharacterScreen.tscn")
	return true

func save_game():
	var playeritems = []
	for player_item in player.items:
		for item_item in items:
			if items[item_item].name == player_item.name:
				playeritems.append(item_item)
	var data = {
		player = {
			maxhitpoints = player.maxhitpoints,
			hitpoints = player.hitpoints,
			maxskillpoints = player.maxskillpoints,
			skillpoints = player.skillpoints,
			vitality = player.vitality,
			strength = player.strength,
			intelligence = player.intelligence,
			speed = player.speed,
			level = player.level,
			experience = player.experience,
			maxexperience = player.maxexperience,
			statpoints = player.statpoints,
			profession = player.profession
		},
		items = playeritems,
		money = currency,
		done = finished
	}
	var file = File.new()
	if file.open("user://data.sav", File.WRITE) != 0:
		print("Couldn't open/create user://data.sav")
		return
	file.store_line(JSON.print(data))
	file.close()

func get_overlay():
	for node in get_tree().get_nodes_in_group("overlay"):
		return node
	return null
	
func play_sound(sound):
	var sound_player = null
	sound_player = AudioStreamPlayer.new()
	sound_player.add_to_group("sound_player")
	get_tree().get_root().add_child(sound_player)
	sound_player.stream = sound
	sound_player.volume_db = -15
	sound_player.play()
	sound_player.connect("finished", sound_player, "queue_free")
	return sound_player

func play_bgm(bgm):
	var bgm_player = null
	for node in get_tree().get_nodes_in_group("bgm_player"):
		bgm_player = node
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		bgm_player.add_to_group("bgm_player")
		get_tree().get_root().add_child(bgm_player)
	bgm_player.stream = bgm
	bgm_player.volume_db = +15
	bgm_player.play()
	bgm_player.connect("finished", bgm_player, "play")
	return bgm_player