extends State
@onready var magus_1: regular_enemy = $"../.."
@onready var refined_magus: EnemyVisuals = $"../../refined Magus"

func enter() -> void:
	await refined_magus.animation_tree.animation_finished
	refined_magus.is_taking_damage=false
	if magus_1.is_target_in_range():
		state_machine.change_state("idle state")
	else : state_machine.change_state("swift chase")
func _process(delta: float) -> void:
	magus_1.move_and_slide()
	magus_1.nullyfying_velocity(delta)
