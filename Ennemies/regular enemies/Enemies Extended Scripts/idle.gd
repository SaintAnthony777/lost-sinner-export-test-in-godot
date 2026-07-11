extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"

func enter() -> void:
	visuals.Grounding("Idle")

func physics_update(_delta) -> void:
	state_logics(_delta)
	if visuals.is_taking_damage:
		state_machine.change_state("taking damage")
func state_logics(delta)->void:
	distance_check()

func distance_check()->void:
	if enemy_body.global_position.distance_to(enemy_body.target.global_position)<=enemy_body.attack_range:
		visuals.is_attacking=true
		state_machine.change_state("attack")
