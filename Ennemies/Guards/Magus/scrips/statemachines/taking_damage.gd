extends State
@onready var magus_1: regular_enemy = $"../.."
@onready var refined_magus: EnemyVisuals = $"../../refined Magus"

func enter() -> void:
	await refined_magus.animation_tree.animation_finished
	refined_magus.is_taking_damage=false
	state_machine.change_state("idle state")
