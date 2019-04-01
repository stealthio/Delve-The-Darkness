extends Node2D

class Room:
	enum TYPES {
		NONE, START, COMBAT, BOSS, SHOP, RANDOM, EXIT, DEPTH
	}
	var type : int = TYPES.NONE
	var cleared : bool = false
	var before_description = "-"
	var cleared_description = "-"
	var icon : Texture = null
	var coordinates : Vector2
	var unique_id : int

	func _init(type : int):
		self.type = type
		unique_id = randi()%2000000000
	
	func to_string():
		return str(type)

var start_rooms = [{
	before_description = "", # dont have to be filled, automatically cleared
	cleared_description = "You're in a cave, the light is dim and the darkness seems to move - As far as you can tell there is no sign of life.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_34.png"
},{
	before_description = "",
	cleared_description = "The smell of sulphur is very strong in this particular area. You can almost taste it.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_34.png"
},{
	before_description = "",
	cleared_description = "Your eyes slowly adjust to the darkness that engulfs you, you find yourself in a cave with rocky, mossy walls. ",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_34.png"
},{
	before_description = "",
	cleared_description = " Horrific sounds are reaching your ears, while you are facing the dark abyss of a cave gazing upon you.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_34.png"
},{
	before_description = "",
	cleared_description = "You entered the cave, you can barely see the hands right before your eyes. Odd sounds of claws scratching the walls and screams are echoing to you.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_34.png"
}]


var combat_rooms = [{
	before_description = "One of the shadows seemed to have moved a little, as you go closer to investigate you're getting attacked!",
	cleared_description = "Corpses of monsters are now cluttering the floor.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_33.png"
},{
	before_description = "You hear a rustle behind you, when turning around, an enemy is lunging at your throat!",
	cleared_description = "The slain monsters are laying in their blood, the stench of iron is disgusting",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_33.png"
},{
	before_description = "You turn a corner and stumble right into a fight, prepare for battle!",
	cleared_description = "The slain monsters are laying in their blood, the stench of iron is disgusting",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_33.png"
},{
	before_description = "You slowly touch around the cave walls to find your way, cold moist stone under your fingers. Wait, thats not stone! Pepare to fight!",
	cleared_description = "The slain monsters are laying in their blood, the stench of iron is disgusting",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_33.png"
},{
	before_description = "Your heart rate increases, the hair on your arm is standing up, your body warned you not a second to late, as a foe attacks your with bloodlust!",
	cleared_description = "The slain monsters are laying in their blood, the stench of iron is disgusting",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_33.png"
}]

var boss_rooms = [{ # Shown after the boss is slain
	before_description = "Heavy steps are echoing through the cavern and they are getting closer. Your heart shrinks, but you ready yourself to fight nontherless! Come on then you big monster!",
	cleared_description = "The alpha of this depth lays in front of your feet, dead!",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_04.png"
},{	before_description = "Angry screams are reaching you, as the intruder has been spotted by the master of this caves section. Will you be able to dethrone the ruler?",
	cleared_description = "A new lord has risen in this caves and you gaze upon new victories!",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_04.png"
},{	before_description = "The bloodlust in front of you is nearly paralizing you, your senses highten, prepare to face a formidable foe!",
	cleared_description = "Fighting is a matter of determination and in the end, your bloodlust was the greater one.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_04.png"
},{	before_description = "You are exhausted, the cave seems to be endless and you really are not up to a fight with this really mean looking enemy but you have to do what you have to do.",
	cleared_description = "He didn't listen to you when you told him that you are not in the mood, so you didn't listen when he pleaded for mercy.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_04.png"
},{	before_description = "There is a heavy, metal reinforced door in front of you, quite unusual in these caves. Yet you have to go through it, so you push it open and stumple into a party hosted by the worst of the worst!",
	cleared_description = "One might call you party pooper now, but at least it went out with a bang!",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_04.png"
}]

var shop_rooms = [{
	before_description = "You see light coming closer, as you enter the area a small goblin-like creature sits between two rocks. On a small blanked he spread out tools and potions - with a price of course.",
	cleared_description = "You've slain the poor creature that has been selling it's goods to others... maybe you're the monster after all",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_11.png"
},{	before_description = "You enter a dimly lit room with a small cat-like creature sitting in front of goods. He offers to trade with you, if you have coin.",
	cleared_description = "First you robbed him off his stuff and then you mentioned that the bad reference should be punishable by death.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_11.png"
},{	before_description = "You see a small opening in the cavern walls and in it an old man, blind from age welcomes you to his tiny shop.",
	cleared_description = "Stealing from a blind man is easy, you made quite the deal.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_11.png"
},{	before_description = "A torch illuminates a little girl sitting on a carpet. She sells you her old toys, as she wants to buy a.. 'smartphone'?",
	cleared_description = "You are all for teaching the value of money, but her parents should be seriously taught a lesson about sending their daughter out into dark caverns.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_11.png"	
},{	before_description = "Your eyes gaze upon shiny items laying on the floor. As you reach for one a bat slaps your hand. It demands payment for its goods!",
	cleared_description = "That bat was a hard negotiator, you think it got the better of you.",
	icon = "res://Graphics/Icons/fantasybadges/Tex_badge_11.png"	
}]

var exit_rooms = [{
	before_description = "There is light at the end of the area, do you want to leave the dungeon?", # shown with a yes no dialogue
	cleared_description = "Well, stay in the darkness then.", # shown with a direction dialogue if no was picked
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_20.png"
},{	before_description = "You seem to have found the exit, do you want to leave the dungeon?", # shown with a yes no dialogue
	cleared_description = "Want to stay, fine with me.", # shown with a direction dialogue if no was picked
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_20.png"
},{	before_description = "The cave widens here, it is an exit! Do you want to leave the dungeon?", # shown with a yes no dialogue
	cleared_description = "The cave widens here.", # shown with a direction dialogue if no was picked
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_20.png"
},{	before_description = "There is a sign here, it says 'Exit'. You can surely trust random signs in caves, do you want to leave the dungeon?", # shown with a yes no dialogue
	cleared_description = "Right, better not trust random signs", # shown with a direction dialogue if no was picked
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_20.png"
},{	before_description = "There is just a boulder. I mean, big rock, in the cave. Do you want to leave the dungeon?", # shown with a yes no dialogue
	cleared_description = "But remember, the pioneers used to ride these babies for miles.", # shown with a direction dialogue if no was picked
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_20.png"
}]

var depth_rooms = [{ # to go deeper into the dungeon
	before_description = "A gaping hole opens up on the floor, deeper into the Dungeon. Do you enter?", # shown with yes no dialogue
	cleared_description = "You ignore the scary hole. Coward.", # shown after no
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_09.png"
},{	before_description = "A ladder like stone structure leads deeper into the Dungeon. Do you go downwards to glory?.", # shown with yes no dialogue
	cleared_description = "You are actively haltering progression on your game, but each to his own.", # shown after no
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_09.png"
},{	before_description = "A crack in a wall seems to go further into the dungeon, do you enter?.", # shown with yes no dialogue
	cleared_description = "You are claustrophobic? Why did you enter a cave in the first place!", # shown after no
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_09.png"
},{	before_description = "You don't know why, but there is a well in the cave. You can climb it down to go deeper into the dungeon.", # shown with yes no dialogue
	cleared_description = "Scared of getting wet I see. At least you could have made a person wet for once in your lifetime.", # shown after no
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_09.png"
},{	before_description = "A dark portal is in front of you, damonic faces carved on it in, their faces wretched with agony. Besides the portal is a ladder that leads deepter into the dungeon, do you climb down?", # shown with yes no dialogue
	cleared_description = "Oh you are staying. Well, good luck near this portal then. Don't mind the screams and purple light emitting out of it.", # shown after no
	icon ="res://Graphics/Icons/fantasybadges/Tex_badge_09.png"
}]

enum DIRECTIONS {
	NORTH, EAST, SOUTH, WEST
}

var map = []
var player_coords : Vector2

func _define_room(room):
	match(room.type):
		Room.TYPES.START:
			var start = start_rooms[randi()%start_rooms.size()]
			room.before_description = start.before_description
			room.cleared_description = start.cleared_description
			room.icon = load(start.icon)
		Room.TYPES.COMBAT:
			var combat = combat_rooms[randi()%combat_rooms.size()]
			room.before_description = combat.before_description
			room.cleared_description = combat.cleared_description
			room.icon = load(combat.icon)
		Room.TYPES.BOSS:
			var boss = boss_rooms[randi()%boss_rooms.size()]
			room.before_description = boss.before_description
			room.cleared_description = boss.cleared_description
			room.icon = load(boss.icon)
		Room.TYPES.SHOP:
			var shop = shop_rooms[randi()%shop_rooms.size()]
			room.before_description = shop.before_description
			room.cleared_description = shop.cleared_description
			room.icon = load(shop.icon)
			Globals.shops.append(room)
		Room.TYPES.RANDOM:
			room.cleared_description = "Random"
			room.icon = load("res://Graphics/Icons/fantasybadges/Tex_badge_28.png")
		Room.TYPES.EXIT:
			var exit = exit_rooms[randi()%exit_rooms.size()]
			room.cleared_description = exit.cleared_description
			room.before_description = exit.before_description
			room.icon = load(exit.icon)
		Room.TYPES.DEPTH:
			var depth = depth_rooms[randi()%depth_rooms.size()]
			room.before_description = depth.before_description
			room.cleared_description = depth.cleared_description
			room.icon = load(depth.icon)

func _init_rooms(amount : int):
	var rooms = []
	for i in amount:
		rooms.append(Room.new(Room.TYPES.COMBAT))
	var player_start = randi()%rooms.size()
	rooms[player_start].type = Room.TYPES.START
	
	var exit = randi()%rooms.size()
	if(rooms[exit].type == Room.TYPES.COMBAT):
		rooms[exit].type = Room.TYPES.EXIT
	
	var random = randi()%rooms.size()
	if(rooms[random].type == Room.TYPES.COMBAT):
		rooms[random].type = Room.TYPES.RANDOM
	
	var shop = randi()%rooms.size()
	if(rooms[shop].type == Room.TYPES.COMBAT):
		rooms[shop].type = Room.TYPES.SHOP
	
	var depth = randi()%rooms.size()
	while(rooms[depth].type != Room.TYPES.COMBAT):
		depth = randi()%rooms.size()
	rooms[depth].type = Room.TYPES.DEPTH
	
	var boss = randi()%rooms.size()
	while(rooms[boss].type != Room.TYPES.COMBAT):
		boss = randi()%rooms.size()
	rooms[boss].type = Room.TYPES.BOSS
	
	for room in rooms:
		_define_room(room)
	
	var x = []
	for i in 30:
		x.append([])
		for j in 30:
			x[i].append(Room.new(0))
			x[i][j].coordinates = Vector2(j,i)
	var c_x = 15
	var c_y = 15
	while(rooms.size() > 0):
		var n_x = 0
		var n_y = 0
		while (abs(n_x) + abs(n_y) > 1) or (abs(n_x) + abs(n_y) == 0):
			n_x = randi()%3-1
			n_y = randi()%3-1
		c_x += n_x
		c_y += n_y
		if x[c_y][c_x].type == 0:
			x[c_y][c_x] = rooms.front()
			x[c_y][c_x].coordinates = Vector2(c_x, c_y)
			rooms.pop_front()
	return x

func _refresh_minimap():
	$CanvasLayer/Minimap.origin = player_coords
	$CanvasLayer/Minimap.map = map
	$CanvasLayer/Minimap.highlight = null
	if is_instance_valid($CanvasLayer/Minimap.highlit_node):
		$CanvasLayer/Minimap.highlit_node.modulate = Color(1,1,1,1)
	$CanvasLayer/Minimap.highlit_node = null
	$CanvasLayer/Minimap.initialize()

func _ready():
	$CanvasLayer/Darkness.modulate.a = Globals.darkness/120.0
	Globals.play_bgm(load("res://BGM/" + Globals.get_random_from_folder("res://BGM/")))
	if Globals.map:
		map = Globals.map
		player_coords = Globals.player_coordinates
		_dialogue_action()
		_refresh_minimap()
	else:
		_generate()
		_continue()
		_refresh_minimap()

func _generate():
	randomize()
	map = _init_rooms(10)
	for roompack in map:
		for room in roompack:
			if room.type == Room.TYPES.START:
				player_coords = room.coordinates
	Globals.map = map
	Globals.player_coordinates = player_coords

func _dialogue_action():
	_refresh_minimap()
	if map[player_coords.y][player_coords.x].cleared:
		_continue()
		return
	var dialog = _create_dialog(map, player_coords)
	if not dialog:
		_continue()
		return
	add_child(dialog)
	dialog.connect("popup_hide", self, "_continue")
	dialog.popup()

func _continue():
	_refresh_minimap()
	$Overlay.refresh()
	var dialog = _create_directional_dialog(map, player_coords)
	add_child(dialog)
	dialog.connect("popup_hide", self, "_dialogue_action")
	dialog.popup()

func _create_directional_dialog(map : Array, coordinates : Vector2):
	var dialog_description = map[coordinates.y][coordinates.x].cleared_description
	var dialog_icon = map[coordinates.y][coordinates.x].icon
	var dialog_buttons = []
	
	var neighbours = _get_neighbours(map, coordinates)
	var dialog = load("res://Objects/Misc/Dialog.tscn").instance()
	for neighbour in neighbours:
		var button_description = neighbour
		match(neighbours[neighbour].type):
			Room.TYPES.COMBAT:
				button_description += "- Combat"
			Room.TYPES.BOSS:
				button_description += "- Boss"
			Room.TYPES.SHOP:
				button_description += "- Shop"
			Room.TYPES.RANDOM:
				button_description += "- Random"
			Room.TYPES.EXIT:
				button_description += "- Exit"
			Room.TYPES.DEPTH:
				button_description += "- Depth"
		if neighbours[neighbour].cleared: button_description += " (Cleared)"
		var button_effects = [[self, "_go", [DIRECTIONS[neighbour.to_upper()]]],[dialog, "_close", []]]
		dialog_buttons.append([button_description, button_effects])
	dialog.connect("button_entered", self, "_dir_button_entered")
	dialog.connect("button_exited", self, "_dir_button_exited")
	dialog.prepare(dialog_description,
				dialog_buttons,
				dialog_icon)
	return dialog

func _dir_button_entered(btn):
	var text = btn.get_node("Label").text
	if text.begins_with("North"):
		$CanvasLayer/Minimap.highlight = Vector2(player_coords.x, player_coords.y-1)
	if text.begins_with("East"):
		$CanvasLayer/Minimap.highlight = Vector2(player_coords.x+1, player_coords.y)
	if text.begins_with("South"):
		$CanvasLayer/Minimap.highlight = Vector2(player_coords.x, player_coords.y+1)
	if text.begins_with("West"):
		$CanvasLayer/Minimap.highlight = Vector2(player_coords.x-1, player_coords.y)

func _dir_button_exited(btn):
	$CanvasLayer/Minimap.highlight = null
	if is_instance_valid($CanvasLayer/Minimap.highlit_node):
		$CanvasLayer/Minimap.highlit_node.modulate = Color(1,1,1,1)
	$CanvasLayer/Minimap.highlit_node = null

func _create_dialog(map : Array, coordinates : Vector2):
	var room = map[coordinates.y][coordinates.x]
	var dialog_description = room.before_description
	var dialog_icon = room.icon
	var dialog_buttons = []
	var dialog = load("res://Objects/Misc/Dialog.tscn").instance()
	
	match(room.type):#NONE, START, COMBAT, BOSS, SHOP, RANDOM, EXIT, DEPTH
		Room.TYPES.START:
			room.cleared = true
			return null
		Room.TYPES.COMBAT:
			dialog_description = room.before_description
			dialog_buttons.append(["Fight", [[self, "_start_fight", []]]])
			dialog_icon = room.icon
			room.cleared = true
		Room.TYPES.BOSS:
			dialog_description = room.before_description
			dialog_buttons.append(["Fight", [[self, "_start_fight", [true]]]])
			dialog_icon = room.icon
			room.cleared = true
		Room.TYPES.SHOP:
			dialog_description = room.before_description
			dialog_buttons.append(["Shop", [[self, "_open_shop", [room]]]])
			dialog_buttons.append(["Attack", [[self, "_start_fight", [true,[Globals.random_from_dic(Globals.items)]]],[self, "_set_room_property",[room, "cleared", true]]]])
			dialog_buttons.append(["Leave", [[dialog, "_close", []]]])
			dialog_icon = room.icon
		Room.TYPES.RANDOM:
			if randi()%2 == 0:
				while(room.type == Room.TYPES.RANDOM):
					room.type = randi()%(Room.TYPES.size() - 2) + 2
					_define_room(room)
					return _create_dialog(map, coordinates)
			else:
				match(randi()%3):
					0:
						var amount = randi()%20+1
						dialog_description = str("You found ", amount, " [color=green]Jewels[/color] laying on the floor")
						dialog_buttons.append(["Nice", [[Globals, "add_currency", [amount]],[dialog, "_close", []]]])
						dialog_icon = load("res://Graphics/Icons/fantasybadges/Tex_badge_22.png")
					1:
						var amount = randi()%20+1
						dialog_description = str("A little thieving creature stole your [color=green] Jewels and ran a depth below.")
						dialog_buttons.append(["Follow", [[self, "_go_deeper", []],[self, "_start_fight", []]]])
						dialog_buttons.append([str("Stay (Lose ", amount, " Jewels)"), [[Globals, "add_currency", [-amount]],[dialog, "_close", []]]])
						dialog_icon = load("res://Graphics/Icons/fantasybadges/Tex_badge_22.png")
					2:
						dialog_description = "There is a well in front of you with stale water - A voice emerged from the depth of it: [color=white]Giv moniez plox[/color]"
						dialog_buttons.append([str("Throw all your jewels inside - ",Globals.currency),[[Globals, "add_currency", [-Globals.currency]],[Globals.player, "level_up", []],[dialog, "_close", []]]])
						dialog_buttons.append([str("Throw half your jewels inside - ",Globals.currency/2),[[Globals, "add_currency", [-Globals.currency/2]],[Globals, "restore_character", [Globals.player]],[dialog, "_close", []]]])
						dialog_buttons.append(["Go away",[[dialog, "_close", []]]])
						dialog_icon = load("res://Graphics/Icons/fantasybadges/Tex_badge_28.png")
				room.cleared = true
		Room.TYPES.EXIT:
			dialog_description = room.before_description
			dialog_buttons.append(["Yes", [[self, "_leave_dungeon", []]]])
			dialog_buttons.append(["No", [[dialog, "_close", []]]])
			dialog_icon = room.icon
		Room.TYPES.DEPTH:
			dialog_description = room.before_description
			dialog_buttons.append(["Enter", [[self, "_go_deeper", []]]])
			dialog_buttons.append(["Ignore", [[dialog, "_close", []]]])
			dialog_icon = room.icon
	dialog.prepare(dialog_description,
				dialog_buttons,
				dialog_icon)
	return dialog

func _go_deeper():
	Globals.play_sound(preload("res://SFX/Delving.wav"))
	Globals.go_deeper()
	if Globals.depth == 10:
		var boss_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
		add_child(boss_dialog)
		boss_dialog.pop("The darkness is with you - with every breath, with every step. You can feel it in your lungs, you can feel it deep within you, slowly consuming you.",
						[["Fight", [[self, "_start_final_boss", []]]]],
						load("res://Graphics/Icons/Badge_necro.png"))
		return
	_generate()
	_continue()

func _leave_dungeon():
	Globals.restore_character(Globals.player)
	Globals.depth = 1
	Globals.darkness = 0
	Globals.darknessinc = 1
	Globals.map = null
	Transition.fade_to("res://CharacterScreen.tscn")

func _set_room_property(room, variable, value):
	if variable in room:
		room.set(variable, value)

func _get_neighbours(map : Array, coordinates : Vector2):
	var neighbours = {
	}
	if map[coordinates.y - 1][coordinates.x].type != 0:
		neighbours["North"] = map[coordinates.y - 1][coordinates.x]
	if map[coordinates.y + 1][coordinates.x].type != 0:
		neighbours["South"] = map[coordinates.y + 1][coordinates.x]
	if map[coordinates.y][coordinates.x + 1].type != 0:
		neighbours["East"] = map[coordinates.y][coordinates.x + 1]
	if map[coordinates.y][coordinates.x - 1].type != 0:
		neighbours["West"] = map[coordinates.y][coordinates.x - 1]
	return neighbours

func _go(direction : int):
	Globals.save_game()
	match(direction):
		DIRECTIONS.NORTH:
			player_coords.y -= 1
		DIRECTIONS.EAST:
			player_coords.x += 1
		DIRECTIONS.SOUTH:
			player_coords.y += 1
		DIRECTIONS.WEST:
			player_coords.x -= 1
	Globals.player_coordinates = player_coords
	Globals.inc_darkness()
	$CanvasLayer/Darkness.modulate.a = Globals.darkness/120.0
	$Overlay.refresh()

func _open_shop(room):
	Globals.play_sound(preload("res://SFX/ShopDoor.wav"))
	Globals.currshop = room
	Transition.fade_to("res://Shop.tscn")

func _start_fight(boss : bool = false, loot = []):
	if not boss:
		Globals.prepare_enemies(randi()%2+1,int(Globals.depth * 1.5), loot)
		Transition.fade_to("res://Main.tscn")
	else:
		Globals.prepare_boss(int(Globals.depth * 1.5), loot)
		Transition.fade_to("res://Main.tscn")

func _start_final_boss():
	Globals.prepare_final_boss()
	Transition.fade_to("res://Main.tscn")
	