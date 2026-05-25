extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter()->void:
	landing_damage_tricks()
	
func physics_update(_delta) -> void:
	state_logics()
func state_logics()->void:
	if character.is_taking_damage:
		state_machine.change_state("idle")
func landing_damage_tricks()->void:
	character.jump_logics("Being hit","Landing")
