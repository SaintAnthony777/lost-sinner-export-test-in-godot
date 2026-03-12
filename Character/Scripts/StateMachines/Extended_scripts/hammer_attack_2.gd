extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.requested_next_attack=false
	character.requested_dash=false
	character.force_character_rotation()
	
func physics_update(_delta) -> void:
	attack_stuff()
	attack_check()
	state_logic(_delta)
	character.check_attack_lunge(2.2)
	
func attack_stuff()->void:
	character.attacking("Normal","Hammer","attack_2")
	
func attack_check()->void:
	if character.can_advance_to_next_atack_pattern : 
		if character.requested_dash:
			character.isrolling=true
			state_machine.change_state("normal_rolling")
		if character.requested_next_attack==true:
			state_machine.change_state("Hammer_attack_3")
	if character.is_attacking==false:
		state_machine.change_state("idle")
	
func state_logic(delta)->void:
	if Input.is_action_just_pressed("Attack_trigger"):character.requested_next_attack=true
	if Input.is_action_just_pressed("sprinting"):character.requested_dash=true
	
	player.camera_rotation_logic(delta)
	
