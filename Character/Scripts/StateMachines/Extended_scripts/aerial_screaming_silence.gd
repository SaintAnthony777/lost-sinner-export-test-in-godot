extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	aerial_trick()
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
	player.camera.fov=lerp(player.camera.fov,105.0,.1)
	player.camera_rotation_logic(_delta)
	
	
func state_logics () -> void :
	if !character.is_divine_dividing:
		camera_check()
		state_machine.change_state("falling")
		
func camera_check()->void:
	if player.camera_position=="left" : player.camera.h_offset=-.7 
	else : player.camera.h_offset=.7
	player.can_switch_camera=true
func aerial_trick():
	character.jump_logics("Special","Screaming_Silence")
	
