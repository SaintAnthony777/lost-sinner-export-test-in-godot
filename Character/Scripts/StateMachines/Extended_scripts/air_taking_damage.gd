extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	air_taking_damage_tricks()
	
func physics_update(delta: float) -> void:
	state_logics(delta)
	
func state_logics(delta)->void:
	if character.health_component.dealt_thrown_time<0.0:
		player.velocity.z=lerp(player.velocity.z,0.0,0.05)
		player.velocity.x=lerp(player.velocity.x,0.0,0.05)
		player.gravity_applying(delta)
		player.move_and_slide()
	if player.is_on_floor():
		state_machine.change_state("Air Taking Damage Landing")

func air_taking_damage_tricks()->void:
	character.jump_logics("Being hit","Air Taking Damage")
	
