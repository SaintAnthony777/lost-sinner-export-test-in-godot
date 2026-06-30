class_name Level extends Node3D
@export var level_name:String=""
@onready var level_shower:PackedScene=preload("res://Componenents/location teller/location_teller.tscn")
@onready var personnage:player_character=$"Personnage"
@onready var save_points_list : Node3D = $"Save points"

func _ready() -> void:
	var lvl_shower:location_teller=level_shower.instantiate()
	var player : player_character = null
	while player == null:
		await get_tree().process_frame
		player = get_tree().current_scene.find_child("Personnage",true,false)
	self.add_child(lvl_shower)
	lvl_shower.label.text=level_name+" - "+get_closest_save_point().save_place_name
	await lvl_shower.animation_player_node.animation_finished
	lvl_shower.queue_free()

func get_closest_save_point()->SavePoint:
	var nearest_savepoint_dist=INF
	var closest_save_point:SavePoint
	for save_p : SavePoint in save_points_list.get_children():
		if save_p.global_position.distance_to(personnage.global_position) < nearest_savepoint_dist:
			nearest_savepoint_dist=save_p.global_position.distance_to(personnage.global_position)
			closest_save_point=save_p
	return closest_save_point
