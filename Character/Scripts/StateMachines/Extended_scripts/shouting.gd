extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	pass
	
func physics_update(_delta) -> void:
	state_logics()
	character.special_attacks("Screaming Silence")
	player.camera.fov=lerp(player.camera.fov,115.0,.1)
	player.camera_rotation_logic(_delta)
func state_logics () -> void :
	if !character.is_shouting:
		state_machine.change_state("idle")
		
	
