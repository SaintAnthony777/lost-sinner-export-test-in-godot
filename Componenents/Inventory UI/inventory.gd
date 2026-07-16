class_name inventory_UI
extends Control

@onready var given_inventory : Inventory
@onready var category_to_be_shown : String =""

@onready var array_of_items : Array[Inventory_Item]
#@onready var item_texture : TextureRect=$"Item_texture"
#@onready var item_desc : Label =$"Descripition panel/ScrollContainer/MarginContainer2/Item description"
@onready var item_to_be_shown : Inventory_Item = null
@onready var item_panel:Panel=$"Item Panel"
#@onready var desc_panel:Panel=$"Descripition panel"
#@onready var label: Label = $"Item title panel/Item title Text container/Label"
#@onready var item_title_panel: Panel = $"Item title panel"
@onready var Pause_UI:PauseMenu=get_tree().get_first_node_in_group("Pause UI")

##remades here
@onready var item_container: GridContainer = $"Item Panel/MarginContainer/item list/Item container"
##short_descriptions
@onready var item_to_be_short_described : Inventory_Item = null
@onready var small_panel_title: Label = $"Short description panel/Short_description_item_panel/Title_cont/Small_panel Title"
@onready var small_panel_short_description: Label = $"Short description panel/Short_description_item_panel/Short desc/Small_panel Short description"
@onready var short_description_item_panel: VBoxContainer = $"Short description panel/Short_description_item_panel"
@onready var short_description_panel: Panel = $"Short description panel"

##large_descriptions
@onready var big_panel_title: Label = $"Item_panel/Long_descriptions_box/Item title Text container/Big_panel Title"
@onready var big_panel_short_descripion: Label = $"Item_panel/Long_descriptions_box/Item First Description container/Big_panel Short descripion"
@onready var long_description: Label = $"Item_panel/Long_descriptions_box/Item Long Description container2/Long description"
@onready var long_descriptions_box: VBoxContainer = $Item_panel/Long_descriptions_box
@onready var item_panel_descriptions: Panel = $Item_panel


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory") and !Pause_UI.visible:
		show_and_hide_inventory()
	if Input.is_action_just_pressed("Pause") and self.visible:
		get_tree().paused = false ; Input.mouse_mode=Input.MOUSE_MODE_CAPTURED ; 
		clear_items_list();
		array_of_items.clear()
		self.hide()
func show_and_hide_inventory()->void:
	if self.visible :
		get_tree().paused = false ; Input.mouse_mode=Input.MOUSE_MODE_CAPTURED ; 
		clear_items_list();
		array_of_items.clear()
	else : 
		get_tree().paused = true ; Input.mouse_mode=Input.MOUSE_MODE_VISIBLE ; 
		clear_items_list()
	self.visible=!self.visible
	
func _process(delta: float) -> void:
	if array_of_items : item_panel.show()
	else : item_panel.hide()
	if item_to_be_short_described:
		short_description_panel.show()
		small_panel_title.text=item_to_be_short_described.item_name
		small_panel_short_description.text=item_to_be_short_described.short_description
	else :
		short_description_panel.hide()
		small_panel_title.text=""
		small_panel_short_description.text=""
	
	if item_to_be_shown:
		item_panel_descriptions.show()
		big_panel_title.text=item_to_be_shown.item_name
		big_panel_short_descripion.text=item_to_be_shown.short_description
		long_description.text=item_to_be_shown.item_description
	else :
		item_panel_descriptions.hide()
		big_panel_title.text=""
		big_panel_short_descripion.text=""
		long_description.text=""
		
func fill_item_list()->void:
	for element : Inventory_Item in given_inventory.Inventory_list:
		if element and element.category==category_to_be_shown:
			array_of_items.append(element)
	if !array_of_items.is_empty():
		for items : Inventory_Item in array_of_items :
			if items : 
				var item_scene:PackedScene=load("res://Componenents/Inventory_button_with_texture/inventory button with texture.tscn")
				var item_to_be_added :inventory_button_with_texture=item_scene.instantiate()
				item_to_be_added.item_given=items
				item_container.add_child(item_to_be_added)
	else : item_to_be_shown = null 
	
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
func _on_gifts_pressed() -> void:
	set_new_array_of_items("gift")

func item_desc_clean()->void:
	big_panel_title.text=""
	big_panel_short_descripion.text=""
	long_description.text=""
	item_to_be_shown=null
	item_to_be_short_described=null
	
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
