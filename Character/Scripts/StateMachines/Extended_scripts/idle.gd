extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	state_logic(_delta)
	input_logic()
	
func state_logic(delta)->void:
	character.normal_motion("Idle_unarmed")
	player.gravity_applying()
	player.camera_rotation_logic(delta)

func input_logic()->void:
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("run")
	if Input.is_action_just_pressed("rolling"):
		character.is_backfliping=true
		state_machine.change_state("backflip")
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("aiming")
	if Input.is_action_just_pressed("locking") and player.current_target:
		state_machine.change_state("locking")
	if Input.is_action_pressed("Blocks"):
		state_machine.change_state("shield_idle")
