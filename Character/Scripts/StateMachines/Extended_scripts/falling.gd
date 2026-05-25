extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.landed=false
	falling_process()
func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta)->void:
	if character.pick_back_hammer and character.equipped_hammer.visible:
		character.has_got_hammer_back()
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	if character.is_taking_damage:
		state_machine.change_state("air taking damage")
	ground_check(delta)
	player.character_moving(player.player_direction)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	player.camera_rotation_logic(delta)
	input_check()
func ground_check(delta)->void:
	player.gravity_applying(delta)
	player.move_and_slide()
	if player.is_on_floor():
		state_machine.change_state("lands")
func input_check()->void:
	if Input.is_action_just_pressed("Special"):
		character.is_divine_dividing=true
		state_machine.change_state("Air_"+player.current_divine_divider)
	if Input.is_action_just_pressed("Grace"):
		character.is_making_grace=true
		state_machine.change_state("Air_"+player.current_grace)
func falling_process()->void:
	character.jump_logics("Normal","Falls")
