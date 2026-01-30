extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

@export var running_speed:=6.0

func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,85.0,.1)
	state_logic(_delta)
	if player.velocity==Vector3.ZERO:
		state_machine.change_state("idle")
	if Input.is_action_pressed("walk"):
		state_machine.change_state("walk")
	if Input.is_action_pressed("sprinting"):
		state_machine.change_state("sprinting")
	if Input.is_action_just_pressed("rolling") : 
		character.isrolling=true
		state_machine.change_state("normal_rolling")
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("aiming")

func state_logic(delta)->void:
	player.SPEED=running_speed
	player.gravity_applying()
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	character.normal_motion("Run")
