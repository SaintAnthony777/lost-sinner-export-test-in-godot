extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.show_equipped_weapon()
	character.can_advance_to_next_atack_pattern=false
func physics_update(_delta) -> void:
	attack_stuff()
	attack_check()
	state_logic(_delta)
	character.check_attack_lunge(3.5,_delta)
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
	character.attacking("Normal","Hammer","attack_dashing")
func attack_check()->void:
	if Input.is_action_just_pressed("sprinting"):
		character.isrolling=true
		state_machine.change_state("normal_rolling")
	if character.is_attacking==false:
		state_machine.change_state("idle")
	if character.can_advance_to_next_atack_pattern==true :
		if Input.is_action_just_pressed("Attack_trigger") : 
			character.is_attacking=true
			state_machine.change_state("hammer_attack_3")
func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
