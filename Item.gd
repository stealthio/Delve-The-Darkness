var name = "None"
var description = "None"
var icon : Texture
var effect : FuncRef
var cost : int
var user = null
var usable : bool = true
var purchaseable : bool = true

func _init(name : String, icon : Texture, f : FuncRef, cost : int = 0, description : String = "", usable = true, purchaseable = true):
	self.name = name
	self.icon = icon
	self.effect = f
	self.cost = cost
	self.description = description
	self.usable = usable
	self.purchaseable = purchaseable

func exec():
	if effect:
		effect.call_func(user)