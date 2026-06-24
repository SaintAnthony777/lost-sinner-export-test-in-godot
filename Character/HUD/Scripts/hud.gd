extends Control


@onready var player:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var divine_divider: TextureRect = $"Maincontainer/HBoxContainer/Abilities and others/Divine divider"
@onready var grace: TextureRect = $"Maincontainer/HBoxContainer/Abilities and others/Grace"
@onready var arcane_comp:arcane_component=$"Health and equip/arcane_component"
@onready var healthrow: MarginContainer = $Maincontainer/HBoxContainer/Barcontainers/Healthrow
@onready var arcane_row: MarginContainer = $"Maincontainer/HBoxContainer/Barcontainers/Arcane row"
@onready var chaos_row: MarginContainer = $"Maincontainer/HBoxContainer/Barcontainers/Chaos Row"
@onready var barcontainers: VBoxContainer = $Maincontainer/HBoxContainer/Barcontainers

func _process(_delta: float) -> void:
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
