extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	gate_opens_trick()
	player.is_busy=false
	character.look_at(player.marker_forced_pos.transform.basis.z)
	if player.Interaction_side=="Back":
		character.rotate_y(PI)
func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	player.camera.fov=95.0
	if player.marker_forced_pos:
		player.global_position=lerp(player.global_position,player.marker_forced_pos.global_position,.1)
func gate_opens_trick()->void:
	character.interaction_motion("opens gate")
	
	
