extends Node3D

class_name character_mesh

var isrolling:bool=false

@onready var animation_tree: AnimationTree = $AnimationTree

func normal_motion(current_action:String)->void:
	grounding("Normal")
	animation_tree.set("parameters/Normal_Transition/transition_request",current_action)
func strafing_motion(direction:Vector2)->void:
	grounding("Aiming")
	animation_tree.set("parameters/Strafe_blendspace/blend_position",direction)
func locking_motion(direction:Vector2)->void:
	grounding("Locking")
	animation_tree.set("parameters/locking_blendspace/blend_position",direction)
func rolling()->void:
	grounding("Rolling")
	animation_tree.set("parameters/roll_transistion/transition_request","rolling")

func grounding(stance:String)->void:
	animation_tree.set("parameters/State/transition_request","Grounded")
	animation_tree.set("parameters/Ground_state/transition_request","Ground_Motion")
	animation_tree.set("parameters/Moving/transition_request",stance)
	
func sprinting()->void:
	grounding("Sprinting")
	
func done_rolling_func()->void:
	isrolling=false
