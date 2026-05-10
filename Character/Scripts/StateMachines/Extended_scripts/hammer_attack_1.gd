extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.requested_next_attack=false
	character.requested_dash=false
	attack_stuff()
func physics_update(_delta) -> void:
	
	attack_check()
	state_logic(_delta)
	
func attack_stuff()->void:
	character.attacking("Normal","Hammer","attack_1")

func attack_check()->void:
	if character.requested_dash:
		character.isrolling=true
		state_machine.change_state("normal_rolling")
	if character.can_advance_to_next_atack_pattern :
		if character.requested_next_attack==true:
			character.can_advance_to_next_atack_pattern=false
			state_machine.change_state("Hammer_attack_2")
	if character.is_attacking==false:
		state_machine.change_state("idle")

func state_logic(delta)->void:
	if Input.is_action_just_pressed("sprinting"):character.requested_dash=true
	if Input.is_action_just_pressed("Attack_trigger") and !character.requested_next_attack:character.requested_next_attack = true
	player.camera_rotation_logic(delta)
	if player.player_move_direction!=Vector3.ZERO:
		player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	else :
		if player.current_target:
			character.look_at(Vector3(
				player.current_target.global_position.x,
				player.global_position.y,
				player.current_target.global_position.z
			))
		else:
			character.look_at(Vector3(
				player.get_target_point().x,
				player.global_position.y,
				player.get_target_point().z
			))
		character.rotate_y(PI)
		
