extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	air_disordonance_tricks()

func physics_update(_delta) -> void:
	air_check(_delta)
	state_logics(_delta)
	
func state_logics(delta)->void:
	player.camera.fov=lerp(player.camera.fov,95.0,.1)
	player.camera_rotation_logic(delta)

func air_check(delta)->void:
	if character.air_rises:
		player.velocity.y+=15.0*delta
	if character.air_stationary:
		player.velocity.y=.0
	if character.air_lashes:
		state_machine.change_state("air_disordonance_fall")
	player.move_and_slide()
func air_disordonance_tricks()->void:
	player.camera.h_offset=.0
	player.can_switch_camera=false
	character.jump_logics("Grace","Air Disordonance")
