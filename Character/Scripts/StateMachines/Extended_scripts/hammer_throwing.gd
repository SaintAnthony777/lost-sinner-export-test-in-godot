extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."


func enter() -> void:
	character.aiming_attack("Hammer_throwing")

func physics_update(_delta) -> void:
	state_logic()
	
func state_logic()->void:
	if !character.is_attacking:
		if !Input.is_action_pressed("Aiming"):
			state_machine.change_state("aiming")
		else :state_machine.change_state("idle")
