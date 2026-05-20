extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var camera_offset_no_offense_here:float

func enter() -> void:
	player.is_locking=true
func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(_delta:float):
	camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
	camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if camera_offset_no_offense_here<2.0:
		camera_offset_no_offense_here=lerp(camera_offset_no_offense_here,-1.0,.1)
	player.SPEED=5.0
	player.camera.fov=lerp(player.camera.fov,100.0,.1)
	player.gravity_applying(_delta)
	if (Input.is_action_just_pressed("locking") or 
	Input.is_action_just_pressed("Aiming") or 
	player.global_position.distance_to(player.current_target.global_position) > 12):
		player.is_locking=false
		player.current_target=null
		state_machine.change_state("normal")
	else: 
		player.player_force_rotation()
		player.camera_force_rotation(camera_offset_no_offense_here)
		player.camera_and_mesh_rotation()
		
	if Input.is_action_just_pressed("Attack_trigger"):
		character.is_attacking=true
		state_machine.change_state("hammer_attack_1")
	if Input.is_action_just_pressed("sprinting"):
		character.isrolling=true
		state_machine.change_state("aiming_rolls")
