extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.normal_motion("Idle_unarmed")
	player.is_busy=false
	character.interacts=false
	await get_tree().create_timer(.5).timeout
	state_machine.change_state("idle")
	
func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	
