extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"
@onready var attack:=""

func enter() -> void:
	print('attacking')
	enemy_body.aiming_at_player()
	var dealt_attack=Attack.new()
	dealt_attack.create_attack(
		randf_range(15.0,18.0),
		randf_range(15.0,17.0),
		"Physical",
		3.0,
		0.0
	)
	visuals.dealt_attack=dealt_attack
	attack_picker()
	visuals.Grounding("Attacking","Attack "+attack)
	await visuals.animation_tree.animation_finished
	visuals.is_attacking=false
	state_machine.change_state("strafing")

func physics_update(_delta) -> void:
	if !visuals.is_attacking:
		state_machine.change_state("Chase")
	if !visuals.is_alive:
		visuals.is_attacking=false
		state_machine.change_state("Dying")
	if visuals.is_taking_damage:
		visuals.is_attacking=false
		state_machine.change_state("taking damage")
func attack_picker()->void:
	attack=str(randi_range(1,4))
