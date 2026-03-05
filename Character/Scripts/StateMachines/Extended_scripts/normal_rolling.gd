extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var character_animation_player: AnimationPlayer = $"../../The Lost Sinner1/AnimationPlayer"

var dash_speed := 10.0

func enter() -> void:
	character.requested_dash_attack = false
	character.requested_sliding = false
func physics_update(_delta) -> void:
	player.gravity_applying()
	state_logic(_delta)
	if Input.is_action_just_pressed("Attack_trigger"): character.requested_dash_attack = true
	if Input.is_action_just_pressed("sprinting") : character.requested_sliding = true
func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.rolling()
	dashlogic()
	if !character.isrolling:
		check_dash_attack()

func dashlogic():
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=dashdirection*dash_speed
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
