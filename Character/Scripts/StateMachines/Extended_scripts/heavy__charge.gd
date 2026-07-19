extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	heavy_charge_logic()
	character.wind_trails_2.show()
func state_logic(delta)->void:
	player.camera.fov=lerp(player.camera.fov,105.0,1.0)
	player.camera_rotation_logic(delta)
	player.aim_at_center()
	if Input.is_action_just_released("Grace"):
		if !character.can_unleash_heavy_charge:
			character.is_making_grace=false
			state_machine.change_state("idle")
		else :state_machine.change_state("heavy charge unleash")
	player.camera_shaking(.2,3.0)

func physics_update(_delta) -> void:
	state_logic(_delta)
	
func heavy_charge_logic()->void:
	player.camera.h_offset=.0
	player.can_switch_camera=false
	character.can_unleash_heavy_charge=false
	character.stopped_charging=false
	character.special_attacks("Graces","Heavy Charge ready")

func exit() -> void:
	character.wind_trails_2.hide()
