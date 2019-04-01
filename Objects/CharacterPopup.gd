extends Popup

func _ready():
	$Portrait.texture = Globals.player.get_node("Sprite").texture
	$Stats/Stats/Level.text = str("Lvl: ", Globals.player.level)
	$Stats/Stats/Experience.text = str("Exp: ", Globals.player.experience, "/", Globals.player.maxexperience)
	$Stats/Stats/Hitpoints.text = str("HP: ", Globals.player.hitpoints, "/", Globals.player.maxhitpoints)
	$Stats/Stats/Skillpoints.text = str("SP: ", Globals.player.skillpoints, "/", Globals.player.maxskillpoints)
	$Stats/Stats/Strength/Strength.text = str("Strength: ", Globals.player.strength)
	$Stats/Stats/Vitality/Vitality.text = str("Vitality: ", Globals.player.vitality)
	$Stats/Stats/Intelligence/Intelligence.text = str("Intelligence: ", Globals.player.intelligence)
	$Stats/Stats/Speed/Speed.text = str("Speed: ", Globals.player.speed)

func _on_Popup_about_to_show():
	$Portrait.texture = Globals.player.get_node("Sprite").texture
	$Stats/Stats/Level.text = str("Lvl: ", Globals.player.level)
	$Stats/Stats/Experience.text = str("Exp: ", Globals.player.experience, "/", Globals.player.maxexperience)
	$Stats/Stats/Hitpoints.text = str("HP: ", Globals.player.hitpoints, "/", Globals.player.maxhitpoints)
	$Stats/Stats/Skillpoints.text = str("SP: ", Globals.player.skillpoints, "/", Globals.player.maxskillpoints)
	$Stats/Stats/Strength/Strength.text = str("Strength: ", Globals.player.strength)
	$Stats/Stats/Vitality/Vitality.text = str("Vitality: ", Globals.player.vitality)
	$Stats/Stats/Intelligence/Intelligence.text = str("Intelligence: ", Globals.player.intelligence)
	$Stats/Stats/Speed/Speed.text = str("Speed: ", Globals.player.speed)

func _on_Popup_popup_hide():
	queue_free()
