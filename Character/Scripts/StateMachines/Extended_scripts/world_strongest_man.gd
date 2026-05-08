extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.can_unleash_divine_divider=false
	player.camera.h_offset=0.0
	player.can_switch_camera=false
func physics_update(_delta) -> void:
	state_logics()
	character.special_attacks("Specials","World strongest man ready")
	player.camera_rotation_logic(_delta)
	player.camera.fov=lerp(player.camera.fov,95.0,.1)
func state_logics () -> void :
	character.look_at(Vector3(player.get_target_point().x,player.global_position.y,player.get_target_point().z))
	if Input.is_action_just_released("Special"):
		if character.can_unleash_divine_divider:
			state_machine.change_state("world strongest man release")
		else:
			player.reset_camera()
			state_machine.change_state("idle")
