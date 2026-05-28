extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var character_animation_player: AnimationPlayer = $"../../The Lost Sinner1/AnimationPlayer"

var dash_speed := 15.0
func enter() -> void: 
	character.requested_slide_attack = false
	player.can_switch_camera=false
	#player.camera_animations.play("camera_sliding")
	
func physics_update(_delta) -> void:
	state_logic(_delta)
	player.camera.fov=lerp(player.camera.fov,100.0,.1)
	if Input.is_action_just_pressed("Attack_trigger") : character.requested_slide_attack = true
	
func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.sliding()
	dashlogic(delta)
	if !character.is_sliding:
		attack_check()
	if character.is_taking_damage:
		character.is_sliding=false
		state_machine.change_state("taking_damage")
	
func attack_check()->void:
	if character.requested_slide_attack:
		character.is_attacking=true
		state_machine.change_state("hammer_attack_dashing")
	else : state_machine.change_state("idle")
	
func exit() -> void:
	player.can_switch_camera=true
	
func dashlogic(_delta):
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity.x=dashdirection.x*dash_speed
	player.velocity.z=dashdirection.z*dash_speed
	player.gravity_applying(_delta)
	player.move_and_slide()
