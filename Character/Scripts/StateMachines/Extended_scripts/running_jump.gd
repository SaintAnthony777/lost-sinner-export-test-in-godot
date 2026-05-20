extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	jump_tricks()

func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta):
	player.move_and_slide()
	player.camera_rotation_logic(delta)
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	velocity_check()
	input_check()
	
func input_check()->void:
	if Input.is_action_just_pressed("sprinting"):
		pass
	if Input.is_action_just_pressed("Special"):
		character.is_divine_dividing=true
		state_machine.change_state("Air_"+player.current_divine_divider)
	if Input.is_action_just_pressed("Grace"):
		character.is_making_grace=true
		state_machine.change_state("Air_"+player.current_grace)
func velocity_check()->void:
	if player.velocity.y<=0:
		state_machine.change_state("falling")
	
func jump_tricks():
	player.velocity.y+=9.0
	character.jump_logics("Normal","Running Jump")
