extends Node3D

class_name character_mesh

func set_to_motion(current_action:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	if current_action!="Idle":
		$AnimationTree.set("parameters/Moves Outputs/transition_request","in_motion")
		$AnimationTree.set("parameters/state/transition_request","normal")
		$AnimationTree.set("parameters/normal/transition_request",current_action)
	else :
		$AnimationTree.set("parameters/Moves Outputs/transition_request","Idle")
func set_to_jump_falls_dash(current_action:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Miscs")
	$AnimationTree.set("parameters/Miscs outputs/transition_request",current_action)
	
func set_to_strafes(direction:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/Moves Outputs/transition_request","in_motion")
	$AnimationTree.set("parameters/state/transition_request","strafing")
	$AnimationTree.set("parameters/strafe_motion/transition_request",direction)
	
