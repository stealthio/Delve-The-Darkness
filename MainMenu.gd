extends Control

func _ready():
	Globals.call_deferred("play_bgm", preload("res://BGM/Delve.ogg"))

func _on_NewGameBtn_pressed():
	var dir = Directory.new()
	dir.remove("user://data.sav")
	Transition.fade_to("res://ClassSelect.tscn")


func _on_LoadGameBtn_pressed():
	if not Globals.load_game():
		var err = preload("res://Objects/Misc/DialogBox.tscn").instance()
		err.add_text("Couldn't load savegame!")
		get_tree().get_root().add_child(err)
		err.rect_global_position = Vector2(400,150)


func _on_CreditsBtn_pressed():
	var credits = preload("res://Objects/Misc/DialogBox.tscn").instance()
	credits.add_text("Credits")
	credits.add_text("Programmer, Design, Game-Design - Stealthix")
	credits.add_text("Assisting Programmer - dunkingdev")
	credits.add_text("Sound, Dargon - Magic_Spark")
	credits.add_text("Writer - Azrail")
	credits.add_text(" ")
	credits.add_text("Additional Credits")
	credits.add_text("Font - BLKCHCRY")
	credits.add_text("Graphical Assets - REXARD")
	credits.add_text("SFX - sonniss.com GDC2019 Bundle")
	credits.add_text("BGM - Youtube Sound-Library")
	credits.add_text("Being Awesome - Buddy Jam")
	get_tree().get_root().add_child(credits)
	credits.rect_global_position = Vector2(400,150)


func _on_EndGameBtn_pressed():
	get_tree().quit()


func _on_Btn_mouse_entered():
	Globals.play_sound(preload("res://SFX/Button.wav"))
