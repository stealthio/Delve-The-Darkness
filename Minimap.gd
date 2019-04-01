extends Control

var map = []
var origin :Vector2
var highlight
var highlit_node
var _highlight_increase : bool = true

var assignment = {
	0 : load("res://Graphics/square_transparent_32.png"), # NONE
	1 : load("res://Graphics/square_black_32.png"), # START
	2 : load("res://Graphics/square_red_32.png"), # COMBAT
	3 : load("res://Graphics/square_red_32.png"), # BOSS
	4 : load("res://Graphics/square_yellow_32.png"), # SHOP
	5 : load("res://Graphics/square_blue_32.png"), # RANDOM
	6 : load("res://Graphics/square_black_32.png"), # EXIT
	7 : load("res://Graphics/square_green_32.png"),
	8 : load("res://Graphics/square_white_32.png")
}

func _process(delta):
	if is_instance_valid(highlit_node):
		if highlit_node.modulate.a <= 0 or highlit_node.modulate.a >=1:
			_highlight_increase = !_highlight_increase
		highlit_node.modulate.a += (0.05 if _highlight_increase else -0.05)
	elif highlight:
		for child in $GridContainer.get_children():
			if child.get_meta("coordinate") == highlight:
				highlit_node = child
	

func initialize():
	for child in $GridContainer.get_children():
		child.queue_free()
	
	for x in [-1,0,1]:
		for y in [-1,0,1]:
			var trect = TextureRect.new()
			var room = map[origin.y+x][origin.x+y]
			if room.coordinates == origin:
				trect.texture = assignment[8]
			else:
			    trect.texture = assignment[room.type]
			trect.set_meta("coordinate", room.coordinates)
			$GridContainer.add_child(trect)
