class_name inventory_button_with_texture extends Control


@onready var item_number: Label = $MarginContainer/Item_texture/Item_number
@onready var item_button: Button = $MarginContainer/Item_texture/Item_button
@onready var item_texture: TextureRect = $MarginContainer/Item_texture

@onready var inventory:inventory_UI=get_parent().owner
@onready var item_given:Inventory_Item



func _ready() -> void:
	item_button.pressed.connect(_pressed)
	item_button.mouse_entered.connect(_hovered)
	item_button.mouse_exited.connect(_exit_hover)
func _process(delta: float) -> void:
	item_number.text=str(item_given.item_number)
	item_texture.texture=load("res://Componenents/Krita Icons for equipement/Icons/"+item_given.item_name+".PNG")
	
func _pressed()->void:
	inventory.item_to_be_shown=item_given
func _hovered()->void:
	inventory.item_to_be_short_described = item_given
func _exit_hover()->void:
	pass
	#inventory.item_to_be_short_described = null
