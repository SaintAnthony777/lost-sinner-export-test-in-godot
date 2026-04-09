extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	falling_trick()
	player.camera.h_offset=lerp(player.camera.h_offset,.0,.1)

func physics_update(_delta) -> void:
	state_logic(_delta)
func state_logic(delta)->void:
	falling_logic(delta)
	if player.is_on_floor():state_machine.change_state("hammer_attack_air_landing")
func falling_logic(delta)->void:
	player.velocity.y-=(205.0+delta)*delta
	player.move_and_slide()
	player.camera_rotation_logic(delta)


func falling_trick()->void:
	player.camera.fov=lerp(player.camera.fov,105.0,.1)
	character.jump_logics("Attacking","Falls")
	
