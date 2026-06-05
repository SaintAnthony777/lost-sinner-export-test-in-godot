extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var camera_offset_no_offense_here:float=1.0

func enter() -> void:
	player.is_locking=true
func physics_update(_delta) -> void:
	state_logic(_delta)
	if !character.is_alive:state_machine.change_state("Dying")
func state_logic(_delta:float):
	if player.current_target:
		camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
		camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if camera_offset_no_offense_here<2.0:
		camera_offset_no_offense_here=lerp(camera_offset_no_offense_here,-1.0,.1)
	player.SPEED=5.0
	player.camera.fov=lerp(player.camera.fov,100.0,.1)
	player.gravity_applying(_delta)
	if (Input.is_action_just_pressed("locking") or 
	Input.is_action_just_pressed("Aiming") or 
	player.global_position.distance_to(player.current_target.global_position) > 12 or !player.current_target.is_alive):
		player.is_locking=false
		player.current_target=null
		state_machine.change_state("normal")
	else: 
		player.player_force_rotation()
		player.camera_force_rotation(camera_offset_no_offense_here)
		player.camera_and_mesh_rotation()
	if character.is_taking_damage:
		state_machine.change_state("taking_damage")
	if Input.is_action_just_pressed("Attack_trigger"):
		character.is_attacking=true
		state_machine.change_state("hammer_attack_1")
	if Input.is_action_just_pressed("sprinting"):
		character.isrolling=true
		state_machine.change_state("locking_rolls")
	if Input.is_action_pressed("Blocks"):
		character.is_blocking=true
		state_machine.change_state("shield_locking")
		
	if Input.is_action_just_pressed("Action trigger") and player.can_interact:
		character.crosshair_layer.hide()
		character.interacts=true
		state_machine.change_state(player.interaction_type)
