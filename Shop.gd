extends CanvasLayer

var for_sale = null
var selected = null

func _ready():
	seed(Globals.currshop.unique_id)
	for shop in Globals.shops:
		if shop.unique_id == Globals.currshop.unique_id:
			for_sale = Globals.currshop.get_meta("items")
			break
	
	if not for_sale:
		for_sale = []
		randomize()
		var x = randi()%6+1
		for i in x:
			var item = Globals.random_from_dic(Globals.items)
			while(!item.purchaseable):
				item = Globals.random_from_dic(Globals.items)
			for_sale.append(item)
		for shop in Globals.shops:
			if shop.unique_id == Globals.currshop.unique_id:
				shop.set_meta("items", for_sale)
				break
	
	for element in for_sale:
		var tb = preload("res://Objects/Misc/ShopButton.tscn").instance()
		tb.get_node("Icon").texture = element.icon
		tb.get_node("Label").text = element.name
		tb.get_node("Currency/Label").text = str(element.cost + randi()%element.cost-element.cost/2)
		tb.set_meta("item",element)
		tb.connect("gui_input", self, "_on_table_item_pressed", [tb])
		$GridContainer.add_child(tb)

func _on_table_item_pressed(event,item):
	if (event is InputEventMouseButton):
		selected = item
		for element in $GridContainer.get_children():
			element.deselect()
		item.select()
		$DescriptionPanel/Description.bbcode_text = item.get_meta("item").description

func _on_Deny_pressed():
	Transition.fade_to("res://TextMap.tscn")

func _on_Confirm_pressed():
	if not selected: return
	var item = selected.get_meta("item")
	if Globals.currency >= int(selected.get_node("Currency/Label").text):
		Globals.currency -= int(selected.get_node("Currency/Label").text)
		$Overlay.refresh()
		Globals.player.add_item(item)
		$GridContainer.remove_child(selected)
		selected.queue_free()
		selected = null
		$DescriptionPanel/Description.bbcode_text = ""
		Globals.play_sound(load("res://SFX/coin/" + Globals.get_random_from_folder("res://SFX/coin/")))