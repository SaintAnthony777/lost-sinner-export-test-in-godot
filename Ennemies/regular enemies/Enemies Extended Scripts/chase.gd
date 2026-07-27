extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"
const CHASE_SPEED:=2.5
const ATTACK_RANGE:=3.0

func enter() -> void:
	visuals.Grounding("Chasing","Slow Chase")
	
func physics_update(_delta) -> void:
	enemy_body.chasing_player(CHASE_SPEED)
	if !visuals.is_alive:
		state_machine.change_state("Dying")
	if visuals.is_taking_damage:
		state_machine.change_state("taking damage")
	if enemy_body.global_position.distance_to(enemy_body.target.global_position)<=enemy_body.attack_range:
		visuals.is_attacking=true
		state_machine.change_state("Attack")
	
