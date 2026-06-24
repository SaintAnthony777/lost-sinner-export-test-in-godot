class_name fracturable extends Node3D

@onready var Thrower_position:Vector3=Vector3.ZERO
@onready var impulse_power:float

func breaker_baby()->void:
	var destruction_dir:=global_position-Thrower_position
	for bodies:RigidBody3D in self.get_children():
		#print(Thrower_position)
		bodies.apply_impulse(destruction_dir.normalized(),bodies.get_child(0).global_position)
	HitStopManager.hit_stop_function(.1,.5)
	await get_tree().create_timer(3.0).timeout
	queue_free()
