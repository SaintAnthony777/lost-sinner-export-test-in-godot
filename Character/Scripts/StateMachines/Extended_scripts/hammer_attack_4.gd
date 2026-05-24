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
	character.check_attack_lunge(4.5)
func attack_stuff()->void:
	var atk:=Attack.new()
	atk.create_attack(
		30.0,
		12.0,
		"Physical",
		3.0,
		0.0
	)
	character.dealt_attack=atk
	character.attacking("Normal","Hammer","attack_4")

func attack_check()->void:
	if character.requested_dash:
			character.isrolling=true
			if !player.is_locking:
				state_machine.change_state("normal_rolling")
			else:
				state_machine.change_state("locking_rolls")
	if character.can_advance_to_next_atack_pattern :
		if character.requested_next_attack==true:
			character.can_advance_to_next_atack_pattern=false
			state_machine.change_state("Hammer_attack_1")
	if character.is_attacking==false:
		if player.is_locking:
			state_machine.change_state("locking")
		else :
			state_machine.change_state("idle")
func state_logic(delta)->void:
	if Input.is_action_just_pressed("sprinting"):character.requested_dash=true
	if Input.is_action_just_pressed("Attack_trigger")and !character.requested_next_attack:character.requested_next_attack=true
	player.camera_rotation_logic(delta)
	if !player.is_locking:
		character.adjust_character_rotation(delta)
	if character.is_taking_damage:
		character.is_attacking=false
		character.requested_next_attack=false
		character.requested_dash=false
		state_machine.change_state("taking_damage")
