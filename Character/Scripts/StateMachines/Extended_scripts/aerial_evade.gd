extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var dash_speed:=10.0

func enter() -> void:
	character.jump_logics("Normal","Air_evade")
func physics_update(_delta) -> void:
	state_logic(_delta)
func state_logic(delta)->void:
	dashlogic(delta)
	player.camera_rotation_logic(delta)
	dash_checks()
	
func dash_checks()->void:
	if player.is_on_floor():
		character.aerial_dashing=false
		state_machine.change_state("Lands")
	if character.aerial_dashing==false:
		state_machine.change_state("Falling")
func dashlogic(delta):
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=dashdirection*dash_speed
	player.gravity_applying(delta)
	player.move_and_slide()
