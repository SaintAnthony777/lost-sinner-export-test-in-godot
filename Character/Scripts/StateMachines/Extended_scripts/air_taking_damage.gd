extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	air_taking_damage_tricks()
	
func physics_update(delta: float) -> void:
	state_logics(delta)
	
func state_logics(delta)->void:
	print(character.health_component.dealt_thrown_time)
	if character.health_component.dealt_thrown_time<0.0:
		player.velocity.x/=1.5
		player.velocity.z/=1.5
		player.gravity_applying(delta)
		player.move_and_slide()
	if player.is_on_floor():
		state_machine.change_state("Air Taking Damage Landing")

func air_taking_damage_tricks()->void:
	character.jump_logics("Being hit","Air Taking Damage")
