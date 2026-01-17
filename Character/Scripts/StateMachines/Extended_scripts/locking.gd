extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(_delta:float):
	player.SPEED=5.0
	if (Input.is_action_just_pressed("locking") or 
	Input.is_action_just_pressed("Aiming") or 
	player.global_position.distance_to(player.current_target.global_position) > 12):
		player.is_locking=false; state_machine.change_state("normal")
	
	if player.current_target :
		player_force_rotation()
		camera_force_rotation()
		camera_and_mesh_rotation()
	
	else : player.is_locking=false; state_machine.change_state("normal")


func player_force_rotation()->void:
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut") 
	var look_pos = Vector3(player.current_target.aiming_node.global_position.x,
	player.global_position.y,
	player.current_target.global_position.z)
	player.character_moving(player.player_direction)
	player.character.locking_motion(input_dir)
	player.character.look_at(look_pos,Vector3.UP)

func camera_force_rotation()->void:
	var camera_look_pos =Vector3(player.current_target.global_position.x,
	player.camera_controller.global_position.y + 2,
	player.current_target.global_position.z)
	player.camera_controller.look_at(camera_look_pos,Vector3.UP)
	
func camera_and_mesh_rotation()->void:
	player.character.rotate_y(PI)
	player.camera_controller.rotate_y(PI)
