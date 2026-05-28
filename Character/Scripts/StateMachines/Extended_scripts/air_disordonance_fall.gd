extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.velocity=Vector3.ZERO
	air_disordonance_tricks()

func physics_update(_delta) -> void:
	velocity_check(_delta)
	player.camera_rotation_logic(_delta)
	state_logic(_delta)
func state_logic(_delta)->void:
	if player.is_on_floor():
		state_machine.change_state("Air_Disordonance_lands")
func velocity_check(delta)->void:
	player.velocity.y-=250*delta 
	player.move_and_slide()
func air_disordonance_tricks()->void:
	character.jump_logics("Grace","Air Disordonance fall")
