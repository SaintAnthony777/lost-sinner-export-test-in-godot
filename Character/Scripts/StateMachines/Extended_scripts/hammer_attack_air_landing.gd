extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	falling_trick()
	player.camera.h_offset=lerp(player.camera.h_offset,.0,.1)

func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta)->void:
	input_check()
	player.camera_rotation_logic(delta)

func falling_trick()->void:
	player.camera.fov=lerp(player.camera.fov,115.0,.1)
	character.jump_logics("Attacking","Lands")
	
func input_check()->void:
	if !character.air_lashes:
		state_machine.change_state("idle")

func exit() -> void:
	if player.camera_position=="left" : player.camera.h_offset=-.7
	else : player.camera.h_offset=.7
	player.can_switch_camera=true
