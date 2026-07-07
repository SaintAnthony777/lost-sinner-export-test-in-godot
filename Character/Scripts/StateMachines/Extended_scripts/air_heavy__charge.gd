extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	air_heavy_charge_logic()
	character.wind_trails_2.show()
	
func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	character.look_at(Vector3(player.get_target_point().x,player.global_position.y,player.get_target_point().z))
	player.camera.fov=lerp(player.camera.fov,95.0,.1)
	state_logic(_delta)

func state_logic(_delta)->void:
	if character.can_unleash_heavy_charge:
		state_machine.change_state("Air Heavy Charge Unleash")

func air_heavy_charge_logic()->void:
	player.can_switch_camera=false
	player.camera.h_offset=.0
	character.can_unleash_heavy_charge=false
	character.stopped_charging=false
	character.jump_logics("Grace","Air Heavy charge")

func exit() -> void:
	character.wind_trails_2.hide()
