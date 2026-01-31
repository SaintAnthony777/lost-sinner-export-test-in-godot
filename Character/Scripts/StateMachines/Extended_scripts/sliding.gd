extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var character_animation_player: AnimationPlayer = $"../../The Lost Sinner1/AnimationPlayer"

var dash_speed := 15.0
func enter() -> void: 
	player.camera_animations.play("camera_sliding")
func physics_update(_delta) -> void:
	player.gravity_applying()
	state_logic(_delta)
	player.camera.fov=lerp(player.camera.fov,100.0,.1)
func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.sliding()
	dashlogic()
	if !character.is_sliding:
		state_machine.change_state("run")

func dashlogic():
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=dashdirection*dash_speed
	player.velocity.y+=0
	player.move_and_slide()
