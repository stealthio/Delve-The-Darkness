extends CanvasLayer

var path = ""

func fade_to(scn_path):
	self.path = scn_path # store the scene path
	$AnimationPlayer.play("fade") # play the transition animation

func change_scene():
	if path != "":
		get_tree().change_scene(path)