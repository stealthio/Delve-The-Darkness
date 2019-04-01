extends CanvasLayer

func _on_ConfirmButton_pressed(cls : int):
	var player = preload("res://Objects/Characters/Player.tscn").instance()
	match(cls):
		0:
			player.profession = player.professions.WARRIOR
		1:
			player.profession = player.professions.ROGUE
		2:
			player.profession = player.professions.WIZARD
	player.initialize()
	Globals.player = player
	player.add_item(Globals.items["plot_note_00"])
	Transition.fade_to("res://CharacterScreen.tscn")