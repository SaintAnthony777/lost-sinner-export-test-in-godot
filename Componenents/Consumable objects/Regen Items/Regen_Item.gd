class_name RegenItem extends Inventory_Item

@export var regen_type : String
@export var regen_value : float
@export var anim_type : String
@export var color_type : Color

func set_regen_type_and_value(type:String,value:float,anim:String,col:Color) -> void :
	self.category="object"
	regen_type=type;regen_value=value;anim_type=anim;color_type=col
