class_name Level extends Node3D
@export var level_name:String=""
@onready var level_shower:PackedScene=preload("res://Componenents/location teller/location_teller.tscn")

func _ready() -> void:
	var lvl_shower:location_teller=level_shower.instantiate()
	self.add_child(lvl_shower)
	lvl_shower.label.text=level_name
	await lvl_shower.animation_player_node.animation_finished
	lvl_shower.queue_free()
	
