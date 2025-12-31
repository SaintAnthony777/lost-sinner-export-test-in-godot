extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var running_speed:=6.0
var walking_speed:=4.0

func physics_update(_delta) -> void:
	state_logics(_delta,player.velocity)
	if player.is_aiming: state_machine.change_state("aiming")
	
func state_logics (delta:float,velocity:Vector3) -> void : 
	
	player.camera_rotation_logic(delta,player.is_aiming,player.is_locking)
	player.character_moving(player.player_direction)
	character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	if velocity.length()>=.2 :
		if Input.is_action_pressed("walk"):
			player.SPEED=walking_speed
			character.normal_motion("Walk")
		else :
			player.SPEED=running_speed
			character.normal_motion("Run")
	else : character.normal_motion("Idle_unarmed")

func character_rotation(move_dir:Vector3,last_mov_dir:Vector3,delta:float):
	if move_dir.length() > 0.2:
		last_mov_dir=move_dir
		var target_angle:=Vector3.BACK.signed_angle_to(last_mov_dir,Vector3.UP)
		character.global_rotation.y=lerp_angle(character.rotation.y,target_angle,player.rotation_speed*delta)
	
