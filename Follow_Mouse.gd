extends TextureRect

func _process(delta):
	rect_global_position = Vector2(get_global_mouse_position().x - texture.get_width() / 2, get_global_mouse_position().y - texture.get_height() / 2)