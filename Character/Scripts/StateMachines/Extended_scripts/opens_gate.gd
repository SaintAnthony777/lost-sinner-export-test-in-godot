extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	gate_opens_trick()
	player.is_busy=false
		
func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	player.camera.fov=95.0
	if player.marker_forced_pos:
		player.global_position=lerp(player.global_position,player.marker_forced_pos.global_position,.1)
	if player.player_look_node:
		character.look_at(Vector3(
			player.player_look_node.global_position.x,
			character.global_position.y,
			player.player_look_node.global_position.z
		))
		character.rotate_y(PI)
	if character.interacts==false:
		state_machine.change_state("idle")
func gate_opens_trick()->void:
	character.interaction_motion("opens gate")
	
	
