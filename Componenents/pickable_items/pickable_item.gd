class_name pickable
extends Node3D

@onready var pickable_id:String=String(get_path())
@onready var interacted : bool = false
@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var inter_area:interaction_area=$interaction_area

@export var item_held : Inventory_Item = Inventory_Item.new()
@export var item_number : int

func _ready() -> void:
	if pickable_id in SaveManager.current_save.picked_items:
		self.queue_free()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Action trigger") and !personnage.is_busy and !interacted and inter_area.interact==self:
		personnage.player_inventory.add_item(item_held,item_number)
		SaveManager.current_save.picked_items.append(pickable_id)
		queue_free()
