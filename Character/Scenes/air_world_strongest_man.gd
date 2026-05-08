extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	aerial_trick()
	player.camera.h_offset=0.0
	player.can_switch_camera=false
func physics_update(_delta) -> void:
	state_logics()
	player.camera.fov=lerp(player.camera.fov,105.0,.1)
	player.camera_rotation_logic(_delta)
	
	
func state_logics () -> void :
	if !character.is_divine_dividing:
		state_machine.change_state("falling")
func exit() -> void:
	player.reset_camera()
func aerial_trick():
	character.jump_logics("Special","World Strongest man")
	
