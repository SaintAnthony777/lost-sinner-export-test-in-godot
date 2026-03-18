extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."


func physics_update(_delta) -> void:
	state_logics(_delta)
	if Input.is_action_just_released("Aiming") : state_machine.change_state("normal")
	if Input.is_action_just_pressed("locking") and player.current_target!=null : state_machine.change_state("locking")
	if Input.is_action_pressed("Blocks") : state_machine.change_state("shield_strafe")
	if Input.is_action_just_pressed("Attack_trigger"):
		character.is_attacking=true
		state_machine.change_state("hammer_throwing")
	if Input.is_action_just_pressed("sprinting"):  
		character.isrolling=true
		state_machine.change_state("aiming_rolls")
	if Input.is_action_just_pressed("Special"):
		character.is_sundowning=true
		state_machine.change_state("Sundown")
func state_logics (delta:float) -> void :
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut")
	player.camera.fov=lerp(player.camera.fov,55.0,.1)
	player.SPEED=3.0
	player.gravity_applying()
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	character.look_at(Vector3(player.looking_at_node.global_position.x,
	player.global_position.y,player.looking_at_node.global_position.z),Vector3.UP,true)
	character.strafing_motion(input_dir)
	
