extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"
const CHASE_SPEED:=2.5
const ATTACK_RANGE:=3.0

func enter() -> void:
	visuals.Grounding("Chasing")
	
func physics_update(_delta) -> void:
	enemy_body.chasing_player(CHASE_SPEED)
	if enemy_body.global_position.distance_to(enemy_body.target.global_position)<=ATTACK_RANGE:
		state_machine.change_state("Attack")
