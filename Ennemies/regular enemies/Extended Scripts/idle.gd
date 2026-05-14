extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"

func _ready() -> void:
	visuals.Grounding("Idle")

func physics_update(_delta) -> void:
	state_logics(_delta)

func state_logics(delta)->void:
	distance_check()

func distance_check()->void:
	print(enemy_body.global_position.distance_squared_to(enemy_body.target.global_position))
