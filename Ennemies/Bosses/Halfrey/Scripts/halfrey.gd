class_name Boss_Visuals extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var Boss_Body:Boss_Root=$"../"

var isattacking:bool=false
var is_lunging:bool=false
var is_turning_at_player:bool=false
var is_ready:bool=false

func Boss_motion(current_state:String,current_action:String)->void:
	animation_tree.set("parameters/Final Output Transition/transition_request",current_state)
	animation_tree.set("parameters/"+current_state+" Motion Transition/transition_request",current_action)

func is_ready_function():
	is_ready=true
func done_attacking()->void:
	isattacking=false
