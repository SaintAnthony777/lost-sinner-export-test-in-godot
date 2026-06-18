extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	pick_logic()
	player.is_busy=false
	character.interacts=true
func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	await character.animation_tree.animation_finished
	character.interacts=false
	state_machine.change_state("idle")
func pick_logic()->void:
	character.interaction_motion("pick up")
