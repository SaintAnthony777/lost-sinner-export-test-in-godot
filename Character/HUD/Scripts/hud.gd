extends Control


@onready var player:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var divine_divider: TextureRect = $"Maincontainer/HBoxContainer/Abilities and others/Divine divider"
@onready var grace: TextureRect = $"Maincontainer/HBoxContainer/Abilities and others/Grace"
@onready var arcane_comp:arcane_component=$"Health and equip/arcane_component"
@onready var healthrow: MarginContainer = $Maincontainer/HBoxContainer/Barcontainers/Healthrow
@onready var arcane_row: MarginContainer = $"Maincontainer/HBoxContainer/Barcontainers/Arcane row"
@onready var gift_row: MarginContainer = $"Maincontainer/HBoxContainer/Barcontainers/Gift Row"
@onready var barcontainers: VBoxContainer = $Maincontainer/HBoxContainer/Barcontainers
@onready var gift: TextureRect = $"Maincontainer/HBoxContainer/Abilities and others/Gift"
@onready var objects: TextureRect = $"Maincontainer/HBoxContainer/Abilities and others/Objects"
@onready var object_quantity: Label = $"Maincontainer/HBoxContainer/Abilities and others/HBoxContainer/Object Quantity"
@onready var object_name: Label = $"Maincontainer/HBoxContainer/Abilities and others/HBoxContainer/Object name"
@onready var object_list:Array[RegenItem]
@onready var current_object_index:int=0
@onready var current_item : RegenItem = RegenItem.new()
func _process(_delta: float) -> void:
	objects_check()
	for element in player.player_inventory.Inventory_list:
			if element and element is Inventory_Item :
				if element.category == "divine divider" and !(player.divine_divider_list.has(element.item_name)):
					player.divine_divider_list.append(element.item_name)
				if element.category == "grace" and !(player.grace_list.has(element.item_name)):
					player.grace_list.append(element.item_name)
	if player.divine_divider_list.size() > 0 or player.grace_list.size() > 0:
		arcane_comp.Arcane_Gauge.modulate=Color(1,1,1,1.0)
	else : arcane_comp.Arcane_Gauge.modulate=Color(1,1,1,0.0)
	if player.current_divine_divider:
		var divine_divider_texture:=load("res://Character/HUD/assets/Icones equipement/Divines dividers/"+player.current_divine_divider+".PNG")
		divine_divider.texture = divine_divider_texture
		if player.character.arcane_component.current_arcane >= player.divine_dividers_consumption_dict.get(player.current_divine_divider) : divine_divider.modulate=Color.html("e61737")
		else : divine_divider.modulate = Color.html("2b0104")
	if player.current_grace:
		if player.character.arcane_component.current_arcane>=player.grace_consumption_dict.get(player.current_grace) : grace.modulate=Color.html("21ffff")
		else : grace.modulate = Color.html("023636")
		grace.texture=load("res://Character/HUD/assets/Icones equipement/Graces/"+player.current_grace+".PNG")
	if player.chosen_gift:
		gift.texture=load("res://Character/HUD/assets/Icones equipement/Gifts/"+player.chosen_gift+".png")
		if player.character.gift_component.current_gift_lvl>25:
			gift.modulate=Color(1.378, 1.378, 0.366)
		if player.character.gift_component.current_gift_lvl==100.0 or player.character.gift_component.is_consummed:
			gift.modulate=Color(11.602, 11.602, 3.369)
		else :
			gift.modulate=Color(0.486, 0.486, 0.106)
	object_switch()

func objects_check()->void:
	for element in player.player_inventory.Inventory_list :
		if element and element is RegenItem and !object_list.has(element):
			object_list.append(element)


func object_switch()->void:
	if object_list.is_empty():
		return
	if Input.is_action_just_pressed("Object Switch"):
		current_object_index+=1
		if current_object_index>=object_list.size() : current_object_index=0 
	current_item = object_list[current_object_index]
	objects.texture=load("res://Character/HUD/assets/Icones equipement/objects/"+current_item.item_name+".PNG")
	object_name.text=current_item.item_name
	object_quantity.text=str(current_item.item_number)
	objects.modulate=current_item.color_type
