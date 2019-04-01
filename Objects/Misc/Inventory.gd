extends Popup

var selected = null

func _ready():
	_reload()
	
func _reload():
	var items = Globals.player.items
	for child in $GridContainer.get_children():
		$GridContainer.remove_child(child)
		child.call_deferred("queue_free")
	for item in items:
		var itmbtn = TextureButton.new()
		itmbtn.texture_normal = item.icon
		itmbtn.expand = true
		itmbtn.material = load("res://Objects/SkillWheel.tres")
		itmbtn.set_meta("item", item)
		itmbtn.connect("pressed", self, "_on_item_pressed", [itmbtn])
		itmbtn.connect("mouse_entered", self, "_on_btn_mouse_enter", [itmbtn])
		itmbtn.connect("mouse_exited", self, "_on_btn_mouse_exited", [itmbtn])
		$GridContainer.add_child(itmbtn)
		itmbtn.rect_min_size = Vector2(256,256)

func _on_btn_mouse_enter(btn):
	Globals.play_sound(preload("res://SFX/Button.wav"))
	btn.rect_scale = Vector2(1.05,1.05)

func _on_btn_mouse_exited(btn):
	btn.rect_scale = Vector2(1,1)

func _on_item_pressed(itembtn):
	for i in $GridContainer.get_children():
		i.modulate = Color(1,1,1)
	itembtn.modulate = Color(0.8,0.8,0.8)
	var item = itembtn.get_meta("item")
	selected = item
	$Description.bbcode_text = str(item.name, "\n", item.description)
	if not item.usable:
		$Use.modulate = Color(0.6,0.6,0.6)
	else:
		$Use.modulate = Color(1,1,1)

func _on_Use_pressed():
	if not selected: return
	if not selected.usable: return
	selected.user = Globals.player
	selected.exec()
	Globals.player.items.erase(selected)
	selected = null
	$Description.bbcode_text = ""
	_reload()

func _on_Inventory_popup_hide():
	queue_free()
