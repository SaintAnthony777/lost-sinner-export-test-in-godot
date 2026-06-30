extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	sitting_idle_logics()
	SaveManager.restore_seeds_and_fruits(player)

func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	if Input.is_action_just_pressed("Action trigger") or Input.is_action_just_pressed("ui_text_backspace"):
		state_machine.change_state("done sitting")
		
func sitting_idle_logics()->void:
	character.interaction_motion("sitting idle")
