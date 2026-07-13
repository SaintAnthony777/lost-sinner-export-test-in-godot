extends State

@onready var enemy_body: regular_enemy = $"../.."
@onready var visuals: EnemyVisuals = $"../../Visuals"

var strafing_time:float
var strafe_duration:float
var base:Vector3=Vector3.ZERO
var strafe_speed := 1.5
var coefficient:int
var strafe_path:String=""
var strafe_direction:Vector3=Vector3.ZERO

func enter() -> void:
	randomize_strafing()
	
func physics_update(_delta) -> void:
	if visuals.is_taking_damage: state_machine.change_state("taking damage")
	if !visuals.is_alive : state_machine.change_state("Dying")
	enemy_body.aiming_at_player()
	enemy_body.velocity.x=strafe_direction.x*strafe_speed
	enemy_body.velocity.z=strafe_direction.z*strafe_speed
	enemy_body.move_and_slide()
	if !enemy_body.is_on_floor():
		enemy_body.velocity.y-=15.0
	strafing_time+=_delta
	if strafing_time>=strafe_duration:
		state_machine.change_state("chase")
		
func randomize_strafing()->void:
	strafing_time=randf_range(2.0,4.0)
	coefficient=[-1,1].pick_random()
	if coefficient==1:strafe_path="Right"
	else: strafe_path = "Left"
	var to_player:=(enemy_body.target.global_position-enemy_body.global_position).normalized()
	strafe_direction=to_player.cross(Vector3.UP)*coefficient
	strafing_time = 0.0
	strafe_duration=randf_range(1.0,2.0)
	visuals.Grounding("Strafing",strafe_path)
	
