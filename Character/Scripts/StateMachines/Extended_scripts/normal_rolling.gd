extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var character_animation_player: AnimationPlayer = $"../../The Lost Sinner1/AnimationPlayer"

var dash_speed := 6.0

func physics_update(_delta) -> void:
	state_logic()
func state_logic():
	
	character.rolling()
	dashlogic()
	await get_tree().create_timer(1.2).timeout
	state_machine.change_state("normal")
	
func dashlogic():
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=dashdirection*dash_speed
	player.velocity.y=0
