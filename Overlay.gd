extends CanvasLayer

func _ready():
	add_to_group("delete_on_game_over")
	add_to_group("overlay")
	refresh()

func refresh():
	$Currency/Label.text = str(Globals.currency)
	$Depth.text = str("Depth: ", Globals.depth, " - ", Globals.currenttheme)
	$Darkness.text = str("Darkness: ", Globals.darkness)
	$DarknessInc.text = str("Darkness Increase: ", int(clamp(Globals.darknessinc - Globals.darknessres + 1,0.0,100.0)))


func _on_Inventory_pressed():
	var inventory = load("res://Objects/Misc/Inventory.tscn").instance()
	inventory.rect_scale = Vector2(0.35,0.35)
	add_child(inventory)
	inventory.popup()

func _on_Character_pressed():
	var character_info = load("res://Objects/CharacterPopup.tscn").instance()
	add_child(character_info)
	character_info.popup()
