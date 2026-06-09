class_name inventory_ui_button
extends Button

@onready var Inventory_UI : inventory_UI = get_parent().get_parent().get_parent()
@onready var item : Inventory_Item

func _init(item:Inventory_Item) -> void:
	item = item

func _ready() -> void:
	pressed.connect(_pressed)

func _pressed() -> void:
	Inventory_UI.item_to_be_shown=item
