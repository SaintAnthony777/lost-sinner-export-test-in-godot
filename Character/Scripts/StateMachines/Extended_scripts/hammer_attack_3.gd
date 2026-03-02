extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	pass
func physics_update(_delta) -> void:
	attack_stuff()
	attack_check()
	state_logic(_delta)
	character.check_attack_lunge(3.5)
func attack_stuff()->void:
	character.attacking("Normal","Hammer","attack_3")

func attack_check()->void:
	if character.can_advance_to_next_atack_pattern and Input.is_action_just_pressed("Attack_trigger"):
		state_machine.change_state("Hammer_attack_1")
	if character.is_attacking==false:
		state_machine.change_state("idle")

func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
