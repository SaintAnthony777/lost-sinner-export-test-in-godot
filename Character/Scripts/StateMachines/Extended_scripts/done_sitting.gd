extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.camera.v_offset=0.0
	standing_logics()
	
func physics_update(_delta) -> void:
		player.camera_rotation_logic(_delta)
		await character.animation_tree.animation_finished
		state_machine.change_state("idle")
		
func standing_logics()->void:
	character.interaction_motion("done sitting")
