extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	state_logic(_delta)
	input_logic()
	
	
func state_logic(delta)->void:
	character.shield_motion("idle",Vector2.ZERO)
	player.gravity_applying()
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("shield_normal")

func input_logic()->void:
	if Input.is_action_just_released("Blocks"):
		state_machine.change_state("idle")
		
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("shield_strafe")
