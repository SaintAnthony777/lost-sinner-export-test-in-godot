extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	jump_tricks()

func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta):
	if character.pick_back_hammer and character.equipped_hammer.visible:
		character.has_got_hammer_back()
	if character.is_taking_damage:
		state_machine.change_state("air taking damage")
	player.move_and_slide()
	player.camera_rotation_logic(delta)
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	player.character_moving(player.player_direction)
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
	player.velocity.y+=10.0
	character.jump_logics("Normal","Start_jumping")
