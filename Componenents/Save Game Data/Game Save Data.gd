class_name GameSaveData
extends Resource

##Player status
@export var max_health:float
@export var current_health:float
@export var max_arcane:float
@export var player_position:Vector3
@export var player_rotation_degrees:Vector3
@export var player_inventory : Inventory = Inventory.new()

###Scene Status
@export var current_scene : String
@export var current_save_place : String
### Var for opened doors
@export var opened_doors_list : Dictionary
## var for destructed props
@export var props_id_list : Array
@export var picked_items : Array
