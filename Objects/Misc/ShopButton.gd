extends Control

func select():
	modulate = Color(0.8,0.8,0.8)

func deselect():
	modulate = Color(1,1,1)

func _on_Clickbox_mouse_entered():
	Globals.play_sound(preload("res://SFX/Button.wav"))
	rect_scale = Vector2(1.05,1.05)

func _on_Clickbox_mouse_exited():
	rect_scale = Vector2(1,1)
