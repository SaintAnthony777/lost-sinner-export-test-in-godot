extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	heavy_charge_stop_logic()

func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	state_logic()

func state_logic()->void:
	if character.stopped_charging:
		state_machine.change_state("heavy charge to idle")

func heavy_charge_stop_logic()->void:
	player.velocity=Vector3.ZERO
	player.move_and_slide()
	character.jump_logics("Grace","Air Heavy Charge Stop")

func exit()->void:
	player.reset_camera()
