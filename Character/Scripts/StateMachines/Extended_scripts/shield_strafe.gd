extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	state_logic(_delta)
	input_logic()
func state_logic(delta)->void:
	player.camera.fov=lerp(player.camera.fov,55.0,.1)
	player.SPEED=3.0
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut") 
	character.look_at(Vector3(player.looking_at_node.global_position.x,player.global_position.y,player.looking_at_node.global_position.z),Vector3.UP,true)
	character.shield_motion("strafe",input_dir)
	
func input_logic()->void:
	if Input.is_action_just_released("Blocks"):
		state_machine.change_state("idle")
		
	if Input.is_action_just_released("Aiming"):
		state_machine.change_state("shield_idle")
	
	if Input.is_action_just_pressed("sprinting"):
		character.isrolling=true
		state_machine.change_state("aiming_rolls")
	
