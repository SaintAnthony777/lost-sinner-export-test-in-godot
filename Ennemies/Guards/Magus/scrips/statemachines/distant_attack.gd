extends State
@onready var magus_1: regular_enemy = $"../.."
@onready var refined_magus: EnemyVisuals = $"../../refined Magus"

func enter() -> void:
	randomize_attack()
	await refined_magus.animation_tree.animation_finished
	state_machine.change_state("idle state")
func physics_update(_delta) -> void:
	magus_1.aiming_at_player()
	if !magus_1.is_on_floor():
		magus_1.velocity.y+=-15
		magus_1.move_and_slide()
func randomize_attack()->void:
	var attack_pattern:String=str(randi_range(2,3))
	refined_magus.Grounding("Attacking","Attack "+attack_pattern)
