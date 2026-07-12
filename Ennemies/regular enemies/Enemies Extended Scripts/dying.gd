extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"

func enter() -> void:
	visuals.Grounding("Dying")
	
	await visuals.animation_tree.animation_finished
	enemy_body.queue_free()
