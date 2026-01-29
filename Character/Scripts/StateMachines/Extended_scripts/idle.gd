extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	state_logic(_delta)
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("run")
	if Input.is_action_just_pressed("rolling"):
		character.is_backfliping=true
		state_machine.change_state("backflip")
func state_logic(delta)->void:
	character.normal_motion("Idle_unarmed")
	player.gravity_applying()
	player.camera_rotation_logic(delta)
