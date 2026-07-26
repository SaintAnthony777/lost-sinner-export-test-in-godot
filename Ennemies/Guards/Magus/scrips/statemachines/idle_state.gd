extends State
@onready var magus_1: regular_enemy = $"../.."
@onready var refined_magus: EnemyVisuals = $"../../refined Magus"

func enter() -> void:
	refined_magus.Grounding("Still motion","Idle")

func update(_delta) -> void:
	magus_1.aiming_at_player()
	if refined_magus.is_taking_damage:
		state_machine.change_state("taking damage")
