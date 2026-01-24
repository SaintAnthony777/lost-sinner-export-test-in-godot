extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	state_logics(_delta)
	if Input.is_action_just_released("Aiming") : state_machine.change_state("normal")
	if Input.is_action_just_pressed("locking") and player.current_target!=null : state_machine.change_state("locking")

func state_logics (delta:float) -> void :
	player.SPEED=3.0
	player.gravity_applying()
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut") 
	character.look_at(Vector3(player.looking_at_node.global_position.x,player.global_position.y,player.looking_at_node.global_position.z),Vector3.UP,true)
	character.strafing_motion(input_dir)
	
