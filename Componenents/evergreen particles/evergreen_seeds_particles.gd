class_name evergreen_particles extends Node3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	evergreen_play()
	
func evergreen_play()->void:
	animation_player.play("evergreen animation")
	await animation_player.animation_finished
	queue_free()
