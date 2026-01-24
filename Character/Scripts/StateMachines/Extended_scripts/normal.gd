extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var running_speed:=6.0
var walking_speed:=4.0

func physics_update(_delta) -> void:
	state_logics(_delta,player.velocity)
	if Input.is_action_pressed("Aiming"):state_machine.change_state("aiming")
	if Input.is_action_just_pressed("locking") and player.current_target!=null : state_machine.change_state("locking")
	if Input.is_action_just_pressed("rolling") : 
		character.isrolling=true
		state_machine.change_state("normal_rolling")
	if Input.is_action_pressed("sprinting"):state_machine.change_state("sprinting")
func state_logics (delta:float,velocity:Vector3) -> void : 
	player.gravity_applying()
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	if velocity.length()>=.2 :
		if Input.is_action_pressed("walk"):
			player.SPEED=walking_speed
			character.normal_motion("Walk")
		else :
			player.SPEED=running_speed
			character.normal_motion("Run")
	else : character.normal_motion("Idle_unarmed")
