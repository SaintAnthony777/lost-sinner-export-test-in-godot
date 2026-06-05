class_name fracturable extends Node3D

@onready var Thrower_position:Vector3=Vector3.ZERO
@onready var impulse_power:float

func breaker_baby()->void:
	for bodies:RigidBody3D in self.get_children():
		print(Thrower_position)
		bodies.apply_impulse(Thrower_position.normalized(),(-Thrower_position)*5.0)
	await get_tree().create_timer(2.0).timeout
	queue_free()
