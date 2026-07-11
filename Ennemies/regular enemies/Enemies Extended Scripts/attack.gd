extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"

func enter() -> void:
	enemy_body.aiming_at_player()
	var dealt_attack=Attack.new()
	dealt_attack.create_attack(
		15.0,
		55.0,
		"Physical",
		3.0,
		0.0
	)
	visuals.dealt_attack=dealt_attack

	visuals.Grounding("Attacking 1")

	await visuals.animation_tree.animation_finished
	visuals.is_attacking=false
	
	if !visuals.is_attacking:
		state_machine.change_state("Idle_Enemy")

func physics_update(_delta) -> void:
	if visuals.is_taking_damage:
		visuals.is_attacking=false
		state_machine.change_state("taking damage")
