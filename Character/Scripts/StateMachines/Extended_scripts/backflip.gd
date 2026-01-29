extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var dash_speed := 6.0


func physics_update(_delta) -> void:
	player.gravity_applying()
	state_logic(_delta)
func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.backflip()
	if character.starts_backflips:
		dashlogic()
	if !character.is_backfliping:
		state_machine.change_state("run")

func dashlogic():
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=-dashdirection*dash_speed
	player.velocity.y=0
	player.move_and_slide()
