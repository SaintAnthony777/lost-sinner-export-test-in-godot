extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var camera_offset_no_offense_here:float=1.0

func enter() -> void:
	player.camera_shaking(.1,1.0)
	taking_damage_tricks()
	
	state_check()
	
	
func physics_update(_delta) -> void:
	if !character.is_alive:player.is_locking=false;state_machine.change_state("Dying")
	player.gravity_applying(_delta)
	
	if player.current_target:
		camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
		camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if player.is_locking:
		player.camera_force_rotation(camera_offset_no_offense_here)
		var look_pos = Vector3(player.current_target.aiming_node.global_position.x,
		player.global_position.y,
		player.current_target.global_position.z)
		self.character.look_at(look_pos,Vector3.UP)
		player.camera_and_mesh_rotation()
	player.gravity_applying(_delta)
	
	
func taking_damage_tricks()->void:
	character.taking_damage("Light")
	
func state_check()->void:
	if character.animation_tree:
		await character.animation_tree.animation_finished 
	character.is_taking_damage=false
	if !character.is_taking_damage:
		if !player.is_locking:
			state_machine.change_state("idle")
		else:
			print("quitted taking damage")
			state_machine.change_state("locking")
