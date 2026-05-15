extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	taking_damage_tricks()
func physics_update(_delta) -> void:
	if !character.is_taking_damage:
		state_machine.change_state("idle")

func taking_damage_tricks()->void:
	character.taking_damage("Light")
