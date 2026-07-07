class_name screaming_particles extends Node3D

@onready var screaming_particles_system: GPUParticles3D = $"screaming particles"

func _ready() -> void:
	screaming_particles_system.emitting=true
	await screaming_particles_system.finished
	queue_free()
