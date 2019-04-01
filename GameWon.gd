extends Node2D

func _ready():
	var dialog = load("res://Objects/Misc/Dialog.tscn").instance()
	add_child(dialog)
	dialog.pop("As you hit the dark replication of yourself one more time it starts fading, - and with it, the darkness of the dungeon fades, too. All the moving shadows, all the lurking creatures - gone. You find yourself not far from the entrance to the cave, which now is nothing more than a abandoned and destroyed laboratory.",
				[["Continue", [[self, "_continue", []],[dialog, "_close", []]]]], load("res://Graphics/backgrounds/cave_inside.png"))
	
func _continue():
	var dialog = load("res://Objects/Misc/Dialog.tscn").instance()
	add_child(dialog)
	dialog.pop("Behind you in the cave stands a man. He looks old, wrinkly, exhausted but happy. 'Thank you for freeing my soul' and with that he slowly starts fading away. Thanks for playing!",
				[["Return to Menu", [[Transition, "fade_to", ["res://MainMenu.tscn"]],[dialog, "_close", []]]]], load("res://Graphics/backgrounds/cave_entrance.png"))