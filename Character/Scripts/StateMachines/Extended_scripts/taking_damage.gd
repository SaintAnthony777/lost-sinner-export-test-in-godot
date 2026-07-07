extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
var camera_offset_no_offense_here:float=1.0

func enter() -> void:
	taking_damage_tricks()
	player.camera_shaking(.1,1.0)
func physics_update(_delta) -> void:
	
	if !character.is_alive:state_machine.change_state("Dying");player.is_locking=false
	player.gravity_applying(_delta)
	if player.current_target:
		camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
		camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if player.is_locking:
		player.camera_force_rotation(camera_offset_no_offense_here)
		player.player_force_rotation()
		player.camera_and_mesh_rotation()
		character.taking_damage("Light")
	if !character.is_taking_damage:
		if !player.is_locking:
			state_machine.change_state("idle")
		else:
			state_machine.change_state("locking")
	else : taking_damage_tricks()
	
func taking_damage_tricks()->void:
	character.taking_damage("Light")
