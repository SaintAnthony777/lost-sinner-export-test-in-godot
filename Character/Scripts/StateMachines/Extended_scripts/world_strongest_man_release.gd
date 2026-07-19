extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.look_at(Vector3(player.get_target_point().x,player.global_position.y,player.get_target_point().z))
	player.camera.h_offset=0.0
	player.can_switch_camera=false
func physics_update(_delta) -> void:
	state_logics()
	character.special_attacks("Specials","World strongest man unleashed")
	player.camera.fov=lerp(player.camera.fov,125.0,.1)
func state_logics () -> void :
	if !character.is_divine_dividing:
		state_machine.change_state("idle")
		
