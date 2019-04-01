var name = "None"
var description = "None"
var icon : Texture
var effect : FuncRef
var uneffect : FuncRef
var par = null
var duration : int
var value

signal timeout

func _init(name : String, icon : Texture, f : FuncRef, duration : int = 2, description : String = "", unf : FuncRef = null, value = null):
	self.name = name
	self.duration = duration
	self.icon = icon
	self.effect = f
	self.description = description
	self.uneffect = unf
	self.value = value

func exec():
	effect.call_func(par, self)
	duration -= 1
	if duration <= 1:
		emit_signal("timeout")

func remove():
	if uneffect:
		uneffect.call_func(par, self)

func duplicate():
	return load("res://Status.gd").new(name, icon, effect, duration, description, uneffect)
	