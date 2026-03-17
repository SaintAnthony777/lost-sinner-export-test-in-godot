extends Node
class_name  slow_mo_node

var slow_motion_active:bool=false

func start_slow_motion(time_sacle:float)->void : 
	Engine.time_scale=time_sacle
	slow_motion_active=true
func stops_slow_motion()->void : 
	Engine.time_scale=1.0
	slow_motion_active=false
