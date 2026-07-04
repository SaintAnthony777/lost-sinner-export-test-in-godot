class_name fracturable extends Node3D

@onready var Thrower_position:Vector3=Vector3.ZERO
@onready var impulse_power:float
@onready var hitsound_node:Hitsound_impact=Hitsound_impact.new()
@export var body_type : String

func breaker_baby()->void:
	if body_type:
		hitsound_node.hitsound_type=body_type
		self.add_child(hitsound_node)
		hitsound_node.load_sound()
	var destruction_dir:=global_position-Thrower_position
	for bodies in self.get_children():
		if bodies is RigidBody3D:
			bodies.apply_impulse(destruction_dir.normalized(),bodies.get_child(0).global_position)
	await get_tree().create_timer(3.0).timeout
	queue_free()
