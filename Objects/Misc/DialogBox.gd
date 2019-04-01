extends Control

signal ok_pressed
var order = 1

func _ready():
	visible = false
	var dialogboxes = get_tree().get_nodes_in_group("dialogbox")
	var previousbox = null
	var previousorder = 0
	for dialog in dialogboxes:
		if dialog.order > previousorder:
			previousorder = dialog.order
			previousbox = dialog
			order = previousorder + 1
	if previousbox:
		previousbox.connect("ok_pressed", self, "_appear")
	else:
		visible = true
	add_to_group("dialogbox")

func _appear():
	visible = true

func _on_OK_pressed():
	emit_signal("ok_pressed")
	call_deferred("queue_free")

func add_text(text):
	var label = Label.new()
	label.text = text
	label.align = Label.ALIGN_CENTER
	label.add_font_override("Font", preload("res://Fonts/Roboto_regular_12.tres"))
	$Content.add_child(label)
	$Content.move_child($Content/OK, $Content.get_child_count() - 1)

func add_image(image):
	var trect = TextureRect.new()
	trect.texture = image
	trect.expand = true
	trect.rect_size = Vector2(64,64)
	$Content.add_child(trect)
	$Content.move_child($Content/OK, $Content.get_child_count() - 1)

func add_button(text, reference):
	$Content.move_child($Content/OK, $Content.get_child_count() - 1)