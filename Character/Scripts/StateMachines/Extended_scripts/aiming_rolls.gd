extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var dash_speed:=9.0
var roll_dir:=Vector3.ZERO
var camera_offset_no_offense_here:float
func enter() -> void:
	check_rotation()

func physics_update(_delta) -> void:
	player.gravity_applying(_delta)
	state_logics(_delta)

func state_logics(delta:float):
	if character.pick_back_hammer and character.equipped_hammer.visible:
		character.has_got_hammer_back()
	if !player.is_locking:
		player.camera.fov=lerp(player.camera.fov,65.0,.1)
		player.camera_rotation_logic(delta)
	else:
		if (player.global_position.distance_to(player.current_target.global_position) > 12):
			player.is_locking=false
			player.current_target=null
			state_machine.change_state("normal")
	character.rolling()
	dashlogic()
	if !character.isrolling:
		if Input.is_action_pressed("Aiming") : state_machine.change_state("aiming")
		elif player.is_locking:state_machine.change_state("locking")
		else : state_machine.change_state("idle")
func dashlogic(): 
	player.velocity=roll_dir*dash_speed
	player.velocity.y=0
	player.move_and_slide()
	
func check_rotation()->void:
	var input_dir:=player.player_move_direction
	if input_dir.length()>.1:
		roll_dir=input_dir.normalized()
	else: roll_dir=character.transform.basis.z.normalized()
	var target_angle = Vector3.BACK.signed_angle_to(roll_dir, Vector3.UP)
	character.global_rotation.y = target_angle
