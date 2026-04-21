extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	air_attack_trick()
func physics_update(_delta) -> void:
	state_logic(_delta)
	player.camera.fov=lerp(player.camera.fov,105.0,.1)
	
func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
	air_ready_check(delta)
	player.camera_rotation_logic(delta)
func air_attack_trick()->void:
	character.jump_logics("Attacking","Ready")
func air_ready_check(delta)->void:
	if character.air_rises:
		player.velocity.y+=15.0*delta
	if character.air_stationary:
		player.velocity.y=0.0
	if character.air_stationary and !Input.is_action_pressed("Attack_trigger"):
		character.lashes_downward()
	if character.air_lashes:
		state_machine.change_state("hammer_attack_air_falling")
	player.move_and_slide()
