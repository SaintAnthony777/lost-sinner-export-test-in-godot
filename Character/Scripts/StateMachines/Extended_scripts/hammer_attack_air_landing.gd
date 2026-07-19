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
	character.jump_logics("Special","Sundown_Lands")
	
func input_check()->void:
	if !character.air_lashes:
		character.is_divine_dividing=false
		state_machine.change_state("idle")

func exit() -> void:
	player.reset_camera()
