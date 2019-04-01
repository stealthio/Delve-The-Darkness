extends Node

func _ready():
	if not Globals.player:
		Globals.player = preload("res://Objects/Characters/Player.tscn").instance()
	_reload()

func _reload():
	$CanvasLayer/Character/Border/Portrait.texture = Globals.player.get_node("Sprite").texture
	$CanvasLayer/Stats/Level.text = str("Lvl: ", Globals.player.level)
	$CanvasLayer/Stats/Experience.text = str("Exp: ", Globals.player.experience, "/", Globals.player.maxexperience)
	$CanvasLayer/Stats/Hitpoints.text = str("HP: ", Globals.player.hitpoints, "/", Globals.player.maxhitpoints)
	$CanvasLayer/Stats/Skillpoints.text = str("SP: ", Globals.player.skillpoints, "/", Globals.player.maxskillpoints)
	$CanvasLayer/Stats/Strength/Strength.text = str("Strength: ", Globals.player.strength)
	$CanvasLayer/Stats/Vitality/Vitality.text = str("Vitality: ", Globals.player.vitality)
	$CanvasLayer/Stats/Intelligence/Intelligence.text = str("Intelligence: ", Globals.player.intelligence)
	$CanvasLayer/Stats/Speed/Speed.text = str("Speed: ", Globals.player.speed)
	
	$CanvasLayer/Stats/Strength/Up.visible = Globals.player.statpoints > 0
	$CanvasLayer/Stats/Vitality/Up.visible = Globals.player.statpoints > 0
	$CanvasLayer/Stats/Intelligence/Up.visible = Globals.player.statpoints > 0
	$CanvasLayer/Stats/Speed/Up.visible = Globals.player.statpoints > 0
	
	$CanvasLayer/Currency/Label.text = str(Globals.currency)
	
	$CanvasLayer/Skills.clear()
	for skill in Globals.player.skills:
		$CanvasLayer/Skills.add_item(skill.name, skill.icon)
		$CanvasLayer/Skills.set_item_metadata($CanvasLayer/Skills.get_item_count()-1,skill)

func _on_FightButton_pressed():
	Transition.fade_to("res://TextMap.tscn")

func _on_Skills_item_selected(index):
	var skill = $CanvasLayer/Skills.get_item_metadata(index)
	$CanvasLayer/SkillDescription.clear()
	$CanvasLayer/SkillDescription.append_bbcode(str(skill.name, "(", skill.cost,")", "\n", skill.description))


func _on_Up_pressed(extra_arg_0):
	match(extra_arg_0):
		"strength":
			Globals.player.strength += 1
		"vitality":
			Globals.player.vitality += 1
		"intelligence":
			Globals.player.intelligence += 1
		"speed":
			Globals.player.speed += 1
	Globals.player.statpoints -= 1
	_reload()


func _on_InventoryBtn_pressed():
	var inventory = load("res://Objects/Misc/Inventory.tscn").instance()
	inventory.rect_scale = Vector2(0.35,0.35)
	$CanvasLayer.add_child(inventory)
	inventory.popup()


func _on_Inventory_popup_hide():
	_reload()

func _on_NewBtn_pressed():
	var new_game_dialogue = preload("res://Objects/Misc/Dialog.tscn").instance()
	$CanvasLayer.add_child(new_game_dialogue)
	new_game_dialogue.pop("Are you sure that you want to return to the menu?",
				[["Yes", [[Transition, "fade_to", ["res://MainMenu.tscn"]],[new_game_dialogue, "_close", []]]],
				["Wait, actually no", [[new_game_dialogue, "_close", []],[new_game_dialogue, "queue_free",[]]]]],
				load("res://Graphics/Icons/fantasybadges/Tex_badge_18.png"))