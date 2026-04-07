extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	air_attack_trick()
	player.can_switch_camera=false

func physics_update(_delta) -> void:
	state_logic(_delta)
	player.camera.h_offset=lerp(player.camera.h_offset,.0,.1)
	player.camera.fov=lerp(player.camera.fov,105.0,.1)
	
func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
	air_ready_check(delta)

func air_attack_trick()->void:
	character.jump_logics("Attacking","Ready")
func air_ready_check(delta)->void:
	if character.air_rises:
		player.velocity.y+=15.0*delta
	if character.air_stationary:
		player.velocity.y=0.0
	if character.air_lashes:
		state_machine.change_state("hammer_attack_air_falling")
	player.move_and_slide()
