class_name inventory_UI
extends Control

@onready var given_inventory : Inventory
@onready var category_to_be_shown : String =""
@onready var item_container : VBoxContainer = $"item list/Item container"
@onready var array_of_items : Array[Inventory_Item]
@onready var item_texture : TextureRect=$"Item_texture"
@onready var item_desc : Label =$"ScrollContainer/MarginContainer2/Item description"
@onready var item_to_be_shown : Inventory_Item = null
@onready var item_panel:Panel=$"Item Panel"
@onready var desc_panel:Panel=$"Descripition panel"
@onready var label: Label = $"Item title Text container/Label"
@onready var item_title_panel: Panel = $"Item title panel"



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		show_and_hide_inventory()

func show_and_hide_inventory()->void:
	if self.visible : 
		get_tree().paused = false ; Input.mouse_mode=Input.MOUSE_MODE_CAPTURED ; clear_items_list();
		array_of_items.clear()
	else : get_tree().paused = true ; Input.mouse_mode=Input.MOUSE_MODE_VISIBLE ; clear_items_list()
	self.visible=!self.visible
	
func _process(delta: float) -> void:
	if array_of_items : item_panel.show()
	else : item_panel.hide()
	if item_to_be_shown:
		item_desc.text=item_to_be_shown.item_description
		label.show()
		item_title_panel.show()
		label.text=item_to_be_shown.item_name
		item_texture.texture = load("res://Componenents/Inventory UI/Renders for equippement/"+item_to_be_shown.item_name+".png")
		desc_panel.show()
	else :
		desc_panel.hide()
		label.hide()
		item_title_panel.hide()
		item_desc.text=""
		item_texture.texture=null
		
func fill_item_list()->void:
	for element:Inventory_Item in given_inventory.Inventory_list:
		if element and element.category==category_to_be_shown:
			array_of_items.append(element)
	if !array_of_items.is_empty():
		for items : Inventory_Item in array_of_items :
			if items : 
				var item_to_be_added : inventory_ui_button=inventory_ui_button.new(items)
				item_to_be_added.item=items
				item_to_be_added.text = items.item_name
				item_container.add_child(item_to_be_added)
	else : item_to_be_shown = null ; 
	
func _on_weapons_pressed() -> void:
	set_new_array_of_items("weapon")
	
func _on_divine_dividers_pressed() -> void:
	set_new_array_of_items("divine divider")
	
func _on_graces_pressed() -> void:
	set_new_array_of_items("grace")
	
func _on_objects_pressed() -> void:
	set_new_array_of_items("object")
func _on_keys_pressed() -> void:
	set_new_array_of_items("key")
func item_desc_clean()->void:
	item_desc.text=""
	item_texture.texture=null
	item_to_be_shown=null
func clear_items_list()->void:
	item_desc_clean()
	for elements in item_container.get_children():
		elements.queue_free()
func set_new_array_of_items(given_category:String)->void:
	array_of_items.clear()
	clear_items_list()
	item_desc_clean()
	category_to_be_shown=given_category
	fill_item_list()
