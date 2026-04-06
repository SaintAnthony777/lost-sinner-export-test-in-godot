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
	
func velocity_check()->void:
	if player.velocity.y<=0:
		state_machine.change_state("falling")
func jump_tricks():
	player.velocity.y+=10.0
	character.jump_logics("Normal","Start_jumping")
