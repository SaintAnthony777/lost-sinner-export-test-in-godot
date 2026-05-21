extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

const CHASE_SPEED:=2.5
const ATTACK_RANGE:=3.0
var chase_direction:=Vector3.ZERO
func enter() -> void:
	Slow_chase_animation()
func physics_update(_delta) -> void:
	slow_chase_physics(_delta)
	Distance_Check()
func slow_chase_physics(delta)->void:
	halfrey_root.aiming_at_player()
	halfrey_root.nav_agent.set_target_position(halfrey_root.target.global_position)
	var next_navigation_point:=halfrey_root.nav_agent.get_next_path_position()
	halfrey_root.velocity=(next_navigation_point-halfrey_root.global_position).normalized()*CHASE_SPEED
	if !halfrey_root.is_on_floor():
		halfrey_root.velocity.y-=15.0
	
	halfrey_root.move_and_slide()
func Slow_chase_animation()->void:
	halfrey.Boss_motion("Move","Walk Forward")
func Distance_Check()->void:
	if halfrey_root.global_position.distance_to(halfrey_root.target.global_position)<=ATTACK_RANGE:
		state_machine.change_state("Attack State")
	elif halfrey_root.global_position.distance_to(halfrey_root.target.global_position)>=30:
		state_machine.change_state("Chasing fierce")
