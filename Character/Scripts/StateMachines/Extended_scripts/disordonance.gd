extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.camera.h_offset=.0
	disordoncance_tricks()
	
func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,105.0,.1)
	state_logic(_delta)

func state_logic(delta)->void:
	if !character.is_making_grace:
		state_machine.change_state("idle")
func disordoncance_tricks()->void:
	character.special_attacks("Graces","Disordonance")
func exit() -> void:
	if player.camera_position=="left" : player.camera.h_offset=-.7 
	else : player.camera.h_offset=.7
	player.camera.v_offset=0.0
	player.can_switch_camera=true
