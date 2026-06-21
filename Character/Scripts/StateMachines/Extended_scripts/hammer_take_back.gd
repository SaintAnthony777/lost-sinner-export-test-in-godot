extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."


func enter() -> void:
	character.unused_weapon_attachment.hide()
func physics_update(_delta) -> void:
	state_logic()

func state_logic()->void:
	character.aiming_attack("Take_back")
	character_force_rotation()
	camera_and_mesh_rotation()
	if !character.pick_back_hammer:
		state_machine.change_state("idle")
func character_force_rotation():
	character.look_at(
		Vector3(
			character.hammer_last_pos.x,
			character.global_position.y,
			character.hammer_last_pos.z,
		)
	)
func camera_and_mesh_rotation()->void:
	player.character.rotate_y(-PI)
