extends Node2D

func _ready():
	$AnimationPlayer.play("default")
	$AnimationPlayer.connect("animation_finished", self, "_delete")

func _delete(param):
	queue_free()