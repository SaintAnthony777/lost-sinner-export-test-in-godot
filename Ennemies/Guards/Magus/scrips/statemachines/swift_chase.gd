extends State

@onready var magus_1: regular_enemy = $"../.."
@onready var refined_magus: EnemyVisuals = $"../../refined Magus"

func _ready() -> void:
	refined_magus.Grounding("Chasing","Slow Chase")

func physics_update(_delta) -> void:
	magus_1.aiming_at_player()
	magus_1.chasing_player(2.0)
	if magus_1.is_target_in_range():
		state_machine.change_state("idle state")
	if refined_magus.is_taking_damage:
		state_machine.change_state("taking damage")
