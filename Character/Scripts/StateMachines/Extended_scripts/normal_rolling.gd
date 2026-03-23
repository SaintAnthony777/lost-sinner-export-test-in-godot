extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var character_animation_player: AnimationPlayer = $"../../The Lost Sinner1/AnimationPlayer"

var dash_speed := 10.0
var roll_dir := Vector3.ZERO
func enter() -> void:
	character.slow_mo.stops_slow_motion()
	check_rotation()
	character.requested_dash_attack = false
	
func physics_update(_delta) -> void:
	player.gravity_applying()
	state_logic(_delta)
	if Input.is_action_just_pressed("Attack_trigger") and character.equipped_hammer.visible : character.requested_dash_attack = true
func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.rolling()
	dashlogic()
	if !character.isrolling:
		check_dash_attack()

func dashlogic():
	player.velocity=roll_dir*dash_speed
	player.velocity.y=0
	player.move_and_slide()

func check_dash_attack()->void:
	if character.requested_dash_attack:
		character.is_attacking=true
		state_machine.change_state("hammer_attack_dashing")
	elif character.requested_sliding : 
		character.is_sliding = true
		state_machine.change_state("sliding")
	else : state_machine.change_state("idle")
	
func check_rotation()->void:
	var input_dir:=player.player_move_direction
	if input_dir.length()>.1:
		roll_dir=input_dir.normalized()
	else: roll_dir=character.transform.basis.z.normalized()
	var target_angle = Vector3.BACK.signed_angle_to(roll_dir, Vector3.UP)
	character.global_rotation.y = target_angle
