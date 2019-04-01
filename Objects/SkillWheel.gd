extends Node2D

var skills = []
var enemy = null
var player = null
var controller = null
var tooltiptimer = null
var tooltip = null

const RAD = 60
const btn_modulate_default = 0.6
const btn_modulate_hover = 1.0
const btn_modulate_oom = 0.2

func initialize():
	var cnt = skills.size()
	var angle = 0
	var angle_intervall = 360/cnt
	var centre_x = global_position.x-32
	var centre_y = global_position.y-32
	var radius = RAD
	for skill in skills:
		skill.user = player
		skill.enemy = enemy
		var btn = TextureButton.new()
		btn.modulate = Color(1,1,1, btn_modulate_default)
		if (player.skillpoints < skill.cost):
			btn.modulate = Color(1,0.5,0.5,btn_modulate_oom)
		btn.texture_normal = skill.icon
		btn.rect_scale = Vector2(0.2,0.2)
		btn.material = load("res://Objects/SkillWheel.tres")
		btn.connect("pressed", skill, "exec")
		btn.connect("mouse_entered", self, "_on_mouse_entered_button", [btn,skill])
		btn.connect("mouse_exited", self, "_on_mouse_exited_button", [btn, skill])
		btn.connect("pressed", controller, "_on_action_pressed", [player, enemy, skill])
		add_child(btn)
		btn.rect_global_position = Vector2(centre_x + cos(deg2rad(angle+angle_intervall)) * radius, centre_y + sin(deg2rad(angle+angle_intervall)) * radius);
		angle += angle_intervall
		btn.show()
func _show_tooltip(skill):
	tooltiptimer.stop()
	tooltip = RichTextLabel.new()
	tooltip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0,0,0,1)
	tooltip.add_stylebox_override("normal", sb)
	tooltip.bbcode_enabled = true
	tooltip.push_align(RichTextLabel.ALIGN_FILL)
	tooltip.bbcode_text = str(skill.name, " ([color=aqua]", skill.cost, "[/color])" ,"\n", skill.description)
	add_child(tooltip)
	tooltip.add_to_group("tooltip")
	tooltip.rect_global_position = get_global_mouse_position()
	var character_count = tooltip.bbcode_text.length()
	tooltip.rect_size = Vector2(150,character_count)

func _on_mouse_entered_button(btn, skill):
	btn.rect_scale = Vector2(0.25,0.25)
	btn.modulate.a = btn_modulate_hover
	tooltiptimer = Timer.new()
	tooltiptimer.connect("timeout", self, "_show_tooltip", [skill])
	add_child(tooltiptimer)
	tooltiptimer.start(1)

func _on_mouse_exited_button(btn, skill):
	if tooltiptimer:
		tooltiptimer.stop()
		tooltiptimer.call_deferred("queue_free")
	
	var tooltips = get_tree().get_nodes_in_group("tooltip")
	for tt in tooltips:
		tt.call_deferred("queue_free")
	tooltip = null
	btn.rect_scale = Vector2(0.2,0.2)
	btn.modulate = Color(1,1,1, btn_modulate_default)
	if (player.skillpoints < skill.cost):
		btn.modulate = Color(1,0.5,0.5,btn_modulate_oom)