extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.look_at(Vector3(player.get_target_point().x,player.global_position.y,player.get_target_point().z))
	character.rotate_y(PI)
	
func physics_update(_delta) -> void:
	state_logics(_delta)
	if !character.is_alive:state_machine.change_state("Dying")

	if Input.is_action_just_released("Aiming") : state_machine.change_state("normal");character.crosshair_layer.hide()

	if Input.is_action_just_pressed("locking") and player.current_target!=null : state_machine.change_state("locking")

	if Input.is_action_pressed("Blocks") : state_machine.change_state("shield_strafe")

	if Input.is_action_just_pressed("Attack_trigger") and character.can_throw_hammer:
		character.is_attacking=true
		state_machine.change_state("hammer_throwing")

	if Input.is_action_just_pressed("sprinting"):  
		character.isrolling=true
		state_machine.change_state("aiming_rolls")

	if Input.is_action_just_pressed("Special"):
		character.is_divine_dividing=true
		character.crosshair_layer.hide()
		state_machine.change_state(player.current_divine_divider)
		
	
func state_logics (delta:float) -> void :
	Crosshair_tricks()
	if character.can_throw_hammer:
		if character.gift_component.is_consummed:
			character.get_weapon_by_gift(player.chosen_gift).show()
		else : character.emptied_enchantement()
	character.show_equipped_weapon()
	aiming_angle_correct()
	character.crosshair_layer.show()
	if character.pick_back_hammer:state_machine.change_state("hammer_take_back")
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut")
	player.camera.fov=lerp(player.camera.fov,55.0,.1)
	player.SPEED=3.0
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	if player.can_switch_camera:
		character.look_at(Vector3(player.get_target_point().x,player.global_position.y,player.get_target_point().z))
		character.rotate_y(PI)
	character.strafing_motion(input_dir)

func hammer_come_back_check():
	if character.pick_back_hammer:
		state_machine.change_state("")
		
func aiming_angle_correct():
	player.hammer_starting_point.look_at(player.get_target_point())
	
func Crosshair_tricks():
	var position2d:=get_viewport().get_visible_rect().size/2
	character.crosshair.global_position=position2d
