extends Node2D

var nodes = []
var root = null
var darknessmod = null
enum nt {
	FIGHT, BOSS,RANDOM, SHOP, HEAL, DEEPER, EXIT
}
var nodelikehood = [nt.FIGHT,nt.FIGHT,nt.FIGHT,nt.FIGHT, nt.FIGHT,nt.FIGHT, 
					nt.BOSS,nt.BOSS, nt.BOSS, 
					nt.RANDOM,nt.RANDOM,nt.RANDOM,
					nt.SHOP,
					nt.HEAL,
					nt.DEEPER,nt.DEEPER,nt.DEEPER,
					nt.EXIT, nt.EXIT]

func _on_exit_clicked():
	var exit_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
	add_child(exit_dialog)
	exit_dialog.pop("Do you want to leave the dungeon?",
					[["Yes", [[self, "_leave_dungeon", []]]],
					 ["No", [[exit_dialog, "_close", []]]]],
					load("res://Graphics/Icons/fantasybadges/Tex_badge_20.png"))


func _leave_dungeon():
	Globals.restore_character(Globals.player)
	Globals.depth = 1
	Globals.darkness = 0
	Globals.darknessinc = 1
	Transition.fade_to("res://CharacterScreen.tscn")

func _on_fight_clicked():
	Globals.prepare_enemies(randi()%2+1,int(Globals.depth * 1.5))
	Transition.fade_to("res://Main.tscn")

func _on_boss_clicked():
	Globals.prepare_boss(Globals.depth * 1.5)
	Transition.fade_to("res://Main.tscn")

func _on_random_clicked():
	var rand_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
	add_child(rand_dialog)
	
	match(randi()%nt.size()):
		nt.FIGHT:
			rand_dialog.pop("Enemies are approaching you",
					[["Fight", [[self, "_on_fight_clicked", []]]]],
					load("res://Graphics/Icons/fantasybadges/Tex_badge_15.png"))
			return
		nt.BOSS:
			rand_dialog.pop("Heavy steps as a massive enemy approaches you",
					[["Fight", [[self, "_on_boss_clicked", []]]]],
					load("res://Graphics/Icons/fantasybadges/Tex_badge_04.png"))
			return
		nt.SHOP:
			_on_shop_clicked()
			return
		nt.HEAL:
			_on_heal_clicked()
			return
	#Random event
	rand_dialog.connect("hide", self , "_progress")
	match(randi()%3):
		0:
			var amount = randi()%20+1
			rand_dialog.pop(str("You found ", amount, " [color=green]Jewels[/color] laying on the floor"),
								[["Nice", [[Globals, "add_currency", [amount]],[rand_dialog, "_close", []]]]],
								load("res://Graphics/Icons/fantasybadges/Tex_badge_22.png"))
			return
		1:
			var amount = randi()%20+1
			rand_dialog.pop(str("A little thieving creature stole your [color=green] Jewels and ran a depth below."),
								[["Follow", [[self, "_go_deeper", []],[self, "_on_fight_clicked", []]]],
								 [str("Stay (Lose ", amount, " Jewels)"), [[Globals, "add_currency", [-amount]],[rand_dialog, "_close", []]]]],
								load("res://Graphics/Icons/fantasybadges/Tex_badge_22.png"))
			return
		2:
			rand_dialog.pop("There is a well in front of you with stale water - A voice emerged from the depth of it: [color=white]Giv moniez plox[/color]",
							[[str("Throw all your jewels inside - ",Globals.currency),[[Globals, "add_currency", [-Globals.currency]],[Globals.player, "level_up", []],[rand_dialog, "_close", []]]],
							 [str("Throw half your jewels inside - ",Globals.currency/2),[[Globals, "add_currency", [-Globals.currency/2]],[Globals, "restore_character", [Globals.player]],[rand_dialog, "_close", []]]],
							 ["Go away",[[rand_dialog, "_close", []]]]],
							load("res://Graphics/Icons/fantasybadges/Tex_badge_28.png"))
			return
	
	rand_dialog.pop("Enemies are approaching you",
					[["Fight", [[self, "_on_fight_clicked", []]]]],
					load("res://Graphics/Icons/fantasybadges/Tex_badge_15.png"))

func _on_heal_clicked():
	var heal_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
	heal_dialog.connect("hide", self , "_progress")
	add_child(heal_dialog)
	heal_dialog.pop("A well with faintly glowing water is in front of you. Do you drink it?",
					[["Yes", [[Globals, "restore_character", [Globals.player]],[heal_dialog, "_close", []]]],
					 ["No", [[heal_dialog, "_close", []]]]],
					load("res://Graphics/Icons/Barbarian_icons_61_b.PNG"))

func _progress():
	Transition.fade_to("res://Map.tscn")
	#get_tree().reload_current_scene()

func _on_shop_clicked():
	Transition.fade_to("res://Shop.tscn")

func _on_deeper_clicked():
	var exit_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
	add_child(exit_dialog)
	exit_dialog.pop("Do you want to go deeper into the dungeon?",
					[["Yes", [[self, "_go_deeper", []]]],
					 ["No", [[exit_dialog, "_close", []]]]],
					load("res://Graphics/Icons/Badge_necro.png"))
	

func _go_deeper():
	Globals.depth += 1
	Globals.darknessinc = 1
	Globals.currenttheme = Globals.themes[randi()%Globals.themes.size()]
	
	if Globals.depth == 10:
		var boss_dialog = preload("res://Objects/Misc/Dialog.tscn").instance()
		add_child(boss_dialog)
		boss_dialog.pop("The darkness is with you - with every breath, with every step. You can feel it in your lungs, you can feel it deep within you, slowly consuming you.",
						[["Fight", [[self, "_final_boss", []]]]],
						load("res://Graphics/Icons/Badge_necro.png"))
		return
		
	Transition.fade_to("res://Map.tscn")

func _final_boss():
	Globals.prepare_final_boss()
	Transition.fade_to("res://Main.tscn")

func _ready():
	randomize()
	Globals.save_game()
	$Root.texture_normal = Globals.player.get_node("Sprite").texture
	if not darknessmod:
		darknessmod = CanvasModulate.new()
		darknessmod.add_to_group("delete_on_game_over")
		add_child(darknessmod)
	Globals.increase_darkness()
	$Overlay.refresh()
	var darknessvalue = clamp(1-float(Globals.darkness)/Globals.darkness_threshold, 0.1, 1)
	darknessmod.color = Color(darknessvalue,darknessvalue,darknessvalue)
	$Light.modulate.a = 1.0 - darknessvalue

	var t = randi()%4+2
	var c = 400/t
	for i in t:
		var n = TextureButton.new()
		n.texture_normal = load("res://icon.png")
		n.rect_scale = Vector2(0.1,0.1)
		n.rect_global_position = Vector2(c+randi()%100,randi()%100+200)
		c += 800/t
		var type = nodelikehood[randi()%nodelikehood.size()]
		match(type):
			nt.FIGHT:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_15.png")
				n.connect("pressed", self, "_on_fight_clicked")
			nt.BOSS:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_04.png")
				n.connect("pressed", self, "_on_boss_clicked")
			nt.RANDOM:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_28.png")
				n.connect("pressed", self, "_on_random_clicked")
			nt.HEAL:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_21.png")
				n.connect("pressed", self, "_on_heal_clicked")
			nt.SHOP:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_11.png")
				n.connect("pressed", self, "_on_shop_clicked")
			nt.DEEPER:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_09.png")
				n.connect("pressed", self, "_on_deeper_clicked")
			nt.EXIT:
				n.texture_normal= load("res://Graphics/Icons/fantasybadges/Tex_badge_20.png")
				n.connect("pressed", self, "_on_exit_clicked")
		n.set_meta("type", type)
		n.connect("mouse_entered", self, "_on_mouse_entered_button", [n])
		n.connect("mouse_exited", self, "_on_mouse_exited_button", [n])
		nodes.append(n)
		add_child_below_node($Root,n)
	root = get_node("Root")
	for n in nodes:
		var l2d = Line2D.new()
		add_child_below_node($Root,l2d)
		l2d.add_point(Vector2(n.rect_global_position.x+n.texture_normal.get_size().x * n.rect_scale.x/2,n.rect_global_position.y+n.texture_normal.get_size().y* n.rect_scale.y/2))
		l2d.add_point(Vector2(root.rect_global_position.x+root.texture_normal.get_size().x * root.rect_scale.x/2, root.rect_global_position.y+root.texture_normal.get_size().y * root.rect_scale.y/2))
		l2d.z_index = -1
		l2d.default_color = Color(0.2,0.2,0.2)
	var l2d = Line2D.new()
	add_child_below_node($Root,l2d)
	l2d.add_point(Vector2(root.rect_global_position.x+root.texture_normal.get_size().x * root.rect_scale.x/2, root.rect_global_position.y+root.texture_normal.get_size().y * root.rect_scale.y/2))
	l2d.add_point(Vector2(root.rect_global_position.x+randi()%50-25,root.rect_global_position.y+300))
	l2d.default_color = Color(0.2,0.2,0.2)
	l2d.z_index = -1
	

func _on_mouse_entered_button(btn):
	btn.rect_scale = Vector2(0.13,0.13)

func _on_mouse_exited_button(btn):
	btn.rect_scale = Vector2(0.1,0.1)

func _on_Root_pressed():
	$Popup.popup()

func _on_InventoryBtn_pressed():
	$Inventory.popup()
