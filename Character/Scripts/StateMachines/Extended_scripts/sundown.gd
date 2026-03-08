extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.camera.h_offset=0.0
	player.camera.v_offset=.2
	player.can_switch_camera=false
func physics_update(_delta) -> void:
	state_logics()
	character.special_attacks("Sundown")
	player.camera.fov=lerp(player.camera.fov,115.0,.1)
	player.camera_rotation_logic(_delta)
func state_logics () -> void :
	if !character.is_sundowning:
		state_machine.change_state("idle")

func exit() -> void:
	if player.camera_position=="left" : player.camera.h_offset=-.7 
	else : player.camera.h_offset=.7
	player.camera.v_offset=0.0
	player.can_switch_camera=true
