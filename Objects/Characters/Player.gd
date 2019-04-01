extends "res://Objects/Character.gd"

var experience = 0
var maxexperience = 0
var statpoints = 0
enum professions {
	NONE, WARRIOR, WIZARD, ROGUE
}
var skillprogression = {
	"warrior":{
		1 : Globals.skills["bash"],
		2 : Globals.skills["bleed"],
		3 : Globals.skills["bloodthirst"],
		4 : Globals.skills["berserk"],
		5 : Globals.skills["cleave"],
		6 : Globals.skills["sacrifice"]
	},
	"wizard":{
		1 : Globals.skills["fireball"],
		2 : Globals.skills["renuvation"],
		3 : Globals.skills["burn"],
		4 : Globals.skills["heal_weak"]
	},
	"rogue":{
		1 : Globals.skills["stab"],
		2 : Globals.skills["bleed"],
		3 : Globals.skills["poison_weapon"],
		4 : Globals.skills["triple_attack"]
	}
}
var profession = professions.NONE
var items = []
var base_xp_mod = 1


func add_item(item):
	item.user = self
	items.append(item)
	if not item.usable:
		item.exec()

func _init():
	maxexperience =  base_xp_mod * (pow(level,2)) * base_xp_mod

func _ready():
	connect("death", self, "_on_death")
	if OS.is_debug_build():
		skills.append(Globals.s_kill)

func _on_death(param):
	var t = Timer.new()
	t.one_shot = true;
	t.connect("timeout", Globals, "game_over", [self])
	add_child(t)
	t.start(1)

func initialize():
	match(profession):
		professions.WARRIOR:
			maxhitpoints = 120
			hitpoints = 120
			maxskillpoints = 60
			skillpoints = 60
			vitality = 12
			strength = 12
			intelligence = 6
			speed = 9
		professions.WIZARD:
			maxhitpoints = 90
			hitpoints = 90
			maxskillpoints = 100
			skillpoints = 100
			vitality = 9
			strength = 7
			intelligence = 14
			speed = 9
		professions.ROGUE:
			maxhitpoints = 100
			hitpoints = 100
			maxskillpoints = 80
			skillpoints = 80
			vitality = 10
			strength = 9
			intelligence = 8
			speed = 13
	level = 1
	gain_skills()

func gain_skills():
	var temp : int = profession
	match(temp):
		1:
			for s in skillprogression["warrior"]:
				if level >= s and not skills.has(skillprogression["warrior"][s]):
					skills.append(skillprogression["warrior"][s])
		2:
			for s in skillprogression["wizard"]:
				if level >= s and not skills.has(skillprogression["wizard"][s]):
					skills.append(skillprogression["wizard"][s])
		3:
			for s in skillprogression["rogue"]:
				if level >= s and not skills.has(skillprogression["rogue"][s]):
					skills.append(skillprogression["rogue"][s])
		

func level_up():
	Globals.play_sound(preload("res://SFX/LevelUp.wav"));
	var oldstats = {
		maxhitpoints = self.maxhitpoints,
		maxskillpoints = self.maxskillpoints,
		vitality = self.vitality,
		strength = self.strength,
		intelligence = self.intelligence,
		speed = self.speed,
		statpoints = self.statpoints
	}

	.level_up()
	statpoints += 2
	gain_skills()
	add_child(load("res://Objects/Effects/Level_Up/Level_Up.tscn").instance())
	
	var overlay = Globals.get_overlay()
	if overlay:
		var rewards = preload("res://Objects/Misc/DialogBox.tscn").instance()
		rewards.add_text("Level Up!")
		rewards.add_text(str("Hitpoints: ", oldstats["maxhitpoints"], " -> ", maxhitpoints))
		rewards.add_text(str("Skillpoints: ", oldstats["maxskillpoints"], " -> ", maxskillpoints))
		rewards.add_text(str("Vitality: ", oldstats["vitality"], " -> ", vitality))
		rewards.add_text(str("Strength: ", oldstats["strength"], " -> ", strength))
		rewards.add_text(str("Intelligence: ", oldstats["intelligence"], " -> ", intelligence))
		rewards.add_text(str("Speed: ", oldstats["speed"], " -> ", speed))
		rewards.add_text(str("Allocateable points: ", oldstats["statpoints"], " -> ", statpoints))
		Globals.get_tree().get_root().add_child(rewards)
		rewards.rect_global_position = Vector2(400,150)

func gain(experience):
	self.experience += experience
	if self.experience >= maxexperience:
		self.experience -= maxexperience
		level_up()
		maxexperience = base_xp_mod * (pow(level,2)) * base_xp_mod