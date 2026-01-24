extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var character_animation_player: AnimationPlayer = $"../../The Lost Sinner1/AnimationPlayer"

var dash_speed := 10.0

func enter() -> void:
	character.rolling()
func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.rolling()
	dashlogic()
	if !character.isrolling:
		state_machine.change_state("normal")

func dashlogic():
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=dashdirection*dash_speed
	player.velocity.y=0
