extends Control


@onready var player:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var divine_divider: TextureRect = $"Health and equip/Divine divider"
@onready var grace: TextureRect = $"Health and equip/Grace"
@onready var arcane_comp:arcane_component=$"Health and equip/arcane_component"
func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	for element in player.player_inventory.Inventory_list:
			if element and element is Inventory_Item :
				if element.category == "divine divider" and !(player.divine_divider_list.has(element.item_name)):
					player.divine_divider_list.append(element.item_name)
				if element.category == "grace" and !(player.grace_list.has(element.item_name)):
					player.grace_list.append(element.item_name)
	if player.divine_divider_list.size() > 0 or player.grace_list.size() > 0:
		arcane_comp.Arcane_Gauge.show()
	else : arcane_comp.Arcane_Gauge.hide()
	if player.current_divine_divider:
		var divine_divider_texture:=load("res://Character/HUD/assets/Icones equipement/Divines dividers/"+player.current_divine_divider+".PNG")
		divine_divider.texture=divine_divider_texture
	if player.current_grace:
		grace.texture=load("res://Character/HUD/assets/Icones equipement/Graces/"+player.current_grace+".PNG")
