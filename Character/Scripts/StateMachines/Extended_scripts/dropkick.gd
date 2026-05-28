extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.can_advance_to_next_atack_pattern=false
func physics_update(_delta) -> void:
	attack_stuff()
	attack_check()
	state_logic(_delta)
	character.check_attack_lunge(6.5,_delta)
func attack_stuff()->void:
	character.special_attacks("Specials","Dropkick")
func attack_check()->void:
	if character.is_attacking==false:
		state_machine.change_state("idle")
	if character.can_advance_to_next_atack_pattern==true and Input.is_action_just_pressed("Attack_trigger") : state_machine.change_state("hammer_attack_2")
func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
