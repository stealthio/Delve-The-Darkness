extends TextureButton
func _on_OptionButton_mouse_entered():
	$Label.add_color_override("font_color", Color(1,1,1))

func _on_OptionButton_mouse_exited():
	$Label.add_color_override("font_color", Color(0,0,0))
