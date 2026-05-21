extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
var camera_offset_no_offense_here:float

func enter() -> void:
	character.is_blocking=true

func physics_update(_delta) -> void:
	state_logic(_delta)
	input_logic()
func state_logic(delta)->void:
	camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
	camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if camera_offset_no_offense_here<2.0:
		camera_offset_no_offense_here=lerp(camera_offset_no_offense_here,-1.0,.1)
	player.camera.fov=lerp(player.camera.fov,100.0,.1)
	player.SPEED=1.0
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut") 
	player.camera_force_rotation(camera_offset_no_offense_here)
	player.player_force_rotation()
	player.camera_and_mesh_rotation()
	character.shield_motion("strafe",input_dir)
	
func input_logic()->void:
	if Input.is_action_just_released("Blocks"):
		character.is_blocking=false
		state_machine.change_state("locking")
		
	if Input.is_action_just_pressed("locking"):
		player.is_locking=false
		state_machine.change_state("shield_idle")
	
	if Input.is_action_just_pressed("sprinting"):
		character.isrolling=true
		state_machine.change_state("locking_rolls")
	
