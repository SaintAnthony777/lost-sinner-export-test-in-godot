extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.camera_shaking(1.0,3.0)
	character.look_at(Vector3(
		player.player_look_node.global_position.x,
		player.global_position.y,
		player.player_look_node.global_position.z
	))
	character.rotate_y(PI)
	character.interaction_motion("praying")
