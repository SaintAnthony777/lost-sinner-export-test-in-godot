extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	print("entered state")
	air_taking_damage_tricks()
func _physics_process(delta: float) -> void:
	state_logics(delta)
func state_logics(delta)->void:
	player.gravity_applying(delta)
	player.move_and_slide()
func air_taking_damage_tricks()->void:
	character.jump_logics("Being hit","Air Taking Damage")
