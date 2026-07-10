extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
var camera_offset_no_offense_here:float

func enter() -> void:
	player.camera_shaking(character.health_component.received_attack.Strength/10,.2)
	character.shield_motion("Blocking impact",Vector2.ZERO)
	
	await character.animation_tree.animation_finished
	character.is_taking_damage= false
	if !character.is_taking_damage:
		player.velocity=Vector3.ZERO
		if !player.is_locking:
			state_machine.change_state("shield_idle")
		else:
			state_machine.change_state("shield_locking")
func physics_update(_delta) -> void:
	if player.current_target:
		camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
		camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	#	
	if player.is_locking:
		player.camera_force_rotation(camera_offset_no_offense_here)
		var look_pos = Vector3(player.current_target.aiming_node.global_position.x,
		player.global_position.y,
		player.current_target.global_position.z)
		self.character.look_at(look_pos,Vector3.UP)
		player.camera_and_mesh_rotation()
	player.gravity_applying(_delta)
	
	
	
func blocking_damage_success()->void:
	character.shield_motion("Blocking impact",Vector2.ZERO)
