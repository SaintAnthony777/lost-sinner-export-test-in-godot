extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
var camera_offset_no_offense_here:float

func enter() -> void:
	print("attack blocked successfully")
	
func physics_update(_delta) -> void:
	blocking_damage_success()
	if player.current_target:
		camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
		camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if player.is_locking:
		player.camera_force_rotation(camera_offset_no_offense_here)
		player.player_force_rotation()
		player.camera_and_mesh_rotation()
		character.shield_motion("Blocking impact",Vector2.ZERO)
	if !character.is_taking_damage:
		if !player.is_locking:
			state_machine.change_state("shield_idle")
		else:
			state_machine.change_state("shield_locking")
	player.gravity_applying(_delta)
func blocking_damage_success()->void:
	character.shield_motion("Blocking impact",Vector2.ZERO)
