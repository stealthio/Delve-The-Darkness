extends Label

var _speed

func create(txt : String, pos : Vector2 ,scale : float = 1, speed : float = 0.3, color : Color = Color(1,1,1)):
	text = txt
	rect_scale.x = scale
	rect_scale.y = scale
	rect_global_position = pos
	_speed = speed
	add_color_override("font_color", color)

func _process(delta):
	rect_global_position.y -= _speed
	modulate.a -= 0.01
	if modulate.a <= 0:
		queue_free()