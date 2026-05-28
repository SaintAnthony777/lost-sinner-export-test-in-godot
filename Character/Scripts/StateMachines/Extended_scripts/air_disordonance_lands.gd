extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."


func enter() -> void:
	air_disordonance_landing_check()
	
func physics_update(_delta) -> void:
	state_logic(_delta)
	player.camera_rotation_logic(_delta)
func state_logic(_delta)->void:
	if !character.is_making_grace:
		state_machine.change_state("idle")
	
func air_disordonance_landing_check()->void:
	character.jump_logics("Grace","Air Disordonance lands")
func exit() -> void:
	character.air_lashes=false
	player.reset_camera()
