extends Popup

var image : Texture
var text : String
var options = []#[["Exit", [[Globals, "hello_world", []],[self, "_close", []]]]]

signal button_entered(button)
signal button_exited(button)

func prepare(text : String, options, image : Texture = null):
	$Image.texture = image
	$DialogText.bbcode_text = text
	var yoffset = 0
	for option in options:
		var btn = preload("res://Objects/Misc/OptionButton.tscn").instance()
		btn.get_node("Label").text = option[0]
		for functionality in option[1]:
			btn.connect("pressed", functionality[0], functionality[1], functionality[2])
		$Options.add_child(btn)
		btn.connect("pressed", Globals, "play_sound", [preload("res://SFX/More Woosh.wav")])
		btn.connect("mouse_entered", self, "_on_btn_mouse_entered", [btn])
		btn.connect("mouse_exited", self, "_on_btn_mouse_exited", [btn])
		btn.rect_position = Vector2(150, 340 + yoffset)
		yoffset += 53

func _on_btn_mouse_entered(btn):
	Globals.play_sound(preload("res://SFX/Button.wav"))
	emit_signal("button_entered", btn)

func _on_btn_mouse_exited(btn):
	emit_signal("button_exited", btn)

func pop(text : String, options, image : Texture = null):
	popup()
	$Image.texture = image
	$DialogText.bbcode_text = text
	var yoffset = 0
	for option in options:
		var btn = preload("res://Objects/Misc/OptionButton.tscn").instance()
		btn.get_node("Label").text = option[0]
		for functionality in option[1]:
			btn.connect("pressed", functionality[0], functionality[1], functionality[2])
		$Options.add_child(btn)
		btn.rect_position = Vector2(150, 340 + yoffset)
		yoffset += 53

func _close():
	hide()
	call_deferred("queue_free")