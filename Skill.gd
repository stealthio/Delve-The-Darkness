var name = "None"
var description = "None"
var icon : Texture
var effect : FuncRef
var cost : int
var user = null
var enemy = null

func _init(name : String, icon : Texture, f : FuncRef, cost : int = 0, description : String = ""):
	self.name = name
	self.icon = icon
	self.effect = f
	self.cost = cost
	self.description = description

func exec():
	if not effect:
		return
	if user.skillpoints >= cost:
		user.skillpoints -= cost
		effect.call_func(user,enemy)
	user.set_bars()
	enemy.set_bars()