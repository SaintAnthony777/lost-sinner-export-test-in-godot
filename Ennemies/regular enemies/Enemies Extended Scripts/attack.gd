extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"

func enter() -> void:
	enemy_body.aiming_at_player()
	enemy_body.dealt_attack=Attack.new()
	enemy_body.dealt_attack.create_attack(
		25.0,
		25.0,
		"Physical",
		3.0,
		0.0
	)
	visuals.Grounding("Attacking 1")

func physics_update(_delta) -> void:
	print(visuals.is_attacking)
	state_logic(_delta)

func state_logic(delta)->void:
	if !visuals.is_attacking:
		visuals.is_attacking=true
		state_machine.change_state("Idle_Enemy")
