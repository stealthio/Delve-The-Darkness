extends ViewportContainer

func _ready():
	pass # Replace with function body.

func focus():
	visible = true
	Viewport.size = rect_size
	$Viewport.set_process_input(true)
	$Viewport.set_process_unhandled_input(true)