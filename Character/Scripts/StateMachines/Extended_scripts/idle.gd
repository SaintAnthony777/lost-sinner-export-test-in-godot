extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	character.is_blocking=false
	character.crosshair_layer.hide()

func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	state_logic(_delta)
	input_logic()
	if !character.is_alive:state_machine.change_state("Dying")
func state_logic(delta)->void:
	if character.pick_back_hammer :
		state_machine.change_state("hammer_take_back")
	character.normal_motion("Idle_unarmed")
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	if !player.is_on_floor():
		character.landed=false
		state_machine.change_state("falling")
	taking_hit_check()
	
func taking_hit_check()->void:
	if character.is_taking_damage:
		state_machine.change_state("taking_damage")
		
func input_logic()->void:
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("run")
		
	if Input.is_action_just_pressed("sprinting"):
		character.is_backfliping=true
		state_machine.change_state("backflip")
		
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("aiming")
		
	if Input.is_action_just_pressed("locking") and player.current_target:
		state_machine.change_state("locking")
		
	if Input.is_action_pressed("Blocks"):
		state_machine.change_state("shield_idle")
		
	if Input.is_action_just_pressed("Attack_trigger") and character.equipped_hammer.visible:
		character.is_attacking=true
		state_machine.change_state("hammer_attack_1")
	
	if Input.is_action_just_pressed("Special"):
		character.is_divine_dividing=true
		state_machine.change_state(player.current_divine_divider)
		
	if Input.is_action_just_pressed("Grace"):
		character.is_making_grace=true
		state_machine.change_state(player.current_grace)
		
	if Input.is_action_just_pressed("Jump trigger"):
		character.landed=false
		state_machine.change_state("Jumping")
