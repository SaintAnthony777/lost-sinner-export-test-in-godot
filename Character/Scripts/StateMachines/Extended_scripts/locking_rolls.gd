extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var roll_direction:=Vector3.ZERO
var roll_speed:=10.0
var input_dir
var camera_basis
var forward
var right
var camera_offset_no_offense_here:float
var checked_vel:=false
func enter() -> void:
	rolling_tricks()
	roll_checks()
func physics_update(_delta) -> void:
	
	camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
	camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if !character.is_alive:state_machine.change_state("Dying")
	status_check()
	continuous_roll()
	rollmoves(_delta)
	check_damage()
	
func roll_checks()->void:
	input_dir = Input.get_vector("Droite", "Gauche", "Bas", "Haut").normalized()
	camera_basis = player.camera_controller.global_transform.basis
	forward = camera_basis.z
	right = camera_basis.x
	forward.y=0
	right.y=0
	if input_dir==Vector2.ZERO:
		roll_direction = forward
	else:
		roll_direction=(right*input_dir.x+forward*input_dir.y).normalized()

func continuous_roll()->void:
	camera_basis=player.camera_controller.global_transform.basis
	right=camera_basis.x
	if input_dir==Vector2.ZERO:
		roll_direction = forward
	else:
		roll_direction=(right*input_dir.x+forward*input_dir.y).normalized()
		
func check_damage()->void:
	if character.is_taking_damage:
		character.isrolling=false
		state_machine.change_state("taking_damage")
		
func rollmoves(delta)->void:
	player.velocity=roll_direction*roll_speed
	player.move_and_slide()
	player.camera_force_rotation(camera_offset_no_offense_here)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	player.camera_controller.rotate_y(PI)
func status_check()->void:
	if !character.isrolling:
		state_machine.change_state("locking")
func rolling_tricks()->void:
	character.rolling()
