class_name Inventory_Item
extends Resource

@export var item_name : String = ""
@export var item_number : int = 1
@export var item_description : String = ""
@export var is_stackable : bool = true
@export var category : String = ""
func create_item(nm:String,nb:int,desc:String,stck:bool,cat:String) -> void:
	item_name=nm
	item_number=nb
	item_description=desc
	is_stackable=stck
	category=cat
