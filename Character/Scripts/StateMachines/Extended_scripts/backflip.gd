extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var dash_speed := 6.0


func physics_update(_delta) -> void:
	player.gravity_applying(_delta)
	state_logic(_delta)
func state_logic(delta):
	player.camera_rotation_logic(delta)
	character.backflip()
	if Input.is_action_just_pressed("Attack_trigger"): character.requested_dash_attack=true
	if character.starts_backflips:
		dashlogic()
	if !character.is_backfliping:
		check_dash_attack()

func dashlogic():
	var dashdirection=character.transform.basis.z.normalized()
	player.velocity=-dashdirection*dash_speed
	player.velocity.y=0
	player.move_and_slide()
func check_dash_attack()->void:
	if character.requested_dash_attack:
		character.is_attacking=true
		state_machine.change_state("hammer_attack_dashing")
	else : state_machine.change_state("idle")
