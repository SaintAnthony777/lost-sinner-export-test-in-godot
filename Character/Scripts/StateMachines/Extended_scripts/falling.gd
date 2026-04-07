extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.landed=false
	falling_process()
func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta)->void:
	ground_check(delta)
	player.character_moving(player.player_direction)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	player.camera_rotation_logic(delta)
	
func ground_check(delta)->void:
	player.gravity_applying(delta)
	player.move_and_slide()
	if player.is_on_floor():
		state_machine.change_state("lands")
	if Input.is_action_just_pressed("Attack_trigger"):
		state_machine.change_state("hammer_attack_air_ready")
func input_check()->void:
	if Input.is_action_just_pressed("sprinting"):
		character.aerial_dashing=true
		state_machine.change_state("aerial evade")
func falling_process()->void:
	character.jump_logics("Normal","Falls")
