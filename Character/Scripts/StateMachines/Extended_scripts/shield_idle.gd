extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	character.is_blocking=true
	
func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	state_logic(_delta)
	input_logic()
	if !character.is_alive:state_machine.change_state("Dying")

func state_logic(delta)->void:
	if character.can_throw_hammer:
		character.show_equipped_weapon()
	if character.pick_back_hammer and character.equipped_hammer.visible:
		character.has_got_hammer_back()
	character.shield_motion("idle",Vector2.ZERO)
	
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("shield_normal")
		
	if character.is_taking_damage:
		player.velocity=Vector3.ZERO
		state_machine.change_state("blocked_successfully")
	
func input_logic()->void:
	if !Input.is_action_pressed("Blocks"):
		character.is_blocking=false
		state_machine.change_state("idle")
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("shield_strafe")
	if Input.is_action_just_pressed("locking") and player.current_target:
		player.is_locking=true
		state_machine.change_state("shield_locking")
