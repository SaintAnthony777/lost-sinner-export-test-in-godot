class_name inventory_ui_button
extends Button

@onready var Inventory_UI : inventory_UI = get_parent().get_parent().get_parent()
@onready var item : Inventory_Item

@onready var style_box_predefined : StyleBoxEmpty = StyleBoxEmpty.new()
@onready var style_box_flat_with_things_on_th_outside : StyleBoxFlat = StyleBoxFlat.new()
func _init(item:Inventory_Item) -> void:
	item = item

func _ready() -> void:
	pressed.connect(_pressed)
	style_box_flat_with_things_on_th_outside.bg_color=Color(0.0,0.0,0.0,0.0)
	style_box_flat_with_things_on_th_outside.border_color = Color.WHITE
	style_box_flat_with_things_on_th_outside.border_width_left = 5 
	style_box_flat_with_things_on_th_outside.border_width_right = 5 
	style_box_flat_with_things_on_th_outside.set_corner_radius_all(2)
	self.add_theme_font_override("font",load("res://Fonts/Cinzel,EB_Garamond/Cinzel/static/Cinzel-Regular.ttf"))
	self.add_theme_font_size_override("font_size",28)
	add_theme_stylebox_override("normal",style_box_predefined)
	add_theme_stylebox_override("hover",style_box_flat_with_things_on_th_outside)
	add_theme_stylebox_override("focus",style_box_predefined)
func _pressed() -> void:
	Inventory_UI.item_to_be_shown=item

func _process(delta: float) -> void:
	self.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	
