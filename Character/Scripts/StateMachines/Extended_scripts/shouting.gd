extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."


func enter() -> void:
	player.camera.h_offset=0.0
	player.can_switch_camera=false
	var current_attack:Attack=Attack.new()
	current_attack.Base_damage=55
	current_attack.Nature="Divine Divider"
	current_attack.Strength=25.0
	current_attack.Stun_time=5.5
	current_attack.arcane_consumption=45.0
	character.dealt_attack=current_attack
	character.arc_component.arcane_consumption(current_attack)

func physics_update(_delta) -> void:
	state_logics()
	character.special_attacks("Specials","Screaming Silence")
	player.camera.fov=lerp(player.camera.fov,125.0,.1)
	player.camera_rotation_logic(_delta)
func state_logics () -> void :
	if !character.is_divine_dividing:
		state_machine.change_state("idle")

func exit() -> void:
	player.reset_camera()
