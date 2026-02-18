extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)

func state_logic(delta)->void:
	character.shield_motion("idle",Vector2.ZERO)
	player.gravity_applying()
	player.camera_rotation_logic(delta)

func input_logic()->void:
	pass
