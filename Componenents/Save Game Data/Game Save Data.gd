class_name GameSaveData
extends Resource

##Player status
@export var max_health:float
@export var current_health:float
@export var current_arcane:float
@export var current_gift_gauge:float
@export var max_gift_gauge:float
@export var max_arcane:float
@export var player_position:Vector3
@export var player_rotation_degrees:Vector3
@export var player_inventory : Inventory = Inventory.new()
@export var player_gift : String
@export var max_fruits:int
@export var max_seeds:int

###Scene Status
@export var current_scene : String
@export var current_save_place : String
### Var for opened doors
@export var opened_doors_list : Dictionary
## var for destructed props
@export var props_id_list : Array
@export var picked_items : Array
