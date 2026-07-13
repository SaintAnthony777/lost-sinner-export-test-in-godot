extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"
var current_react_dir:String=""

func enter() -> void:
	
	await visuals.animation_tree.animation_finished
	visuals.is_taking_damage=false
	if !visuals.is_taking_damage:
		state_machine.change_state("idle_enemy")

func physics_update(_delta) -> void:
	if !visuals.is_alive:visuals.is_taking_damage=false;state_machine.change_state("Dying")
