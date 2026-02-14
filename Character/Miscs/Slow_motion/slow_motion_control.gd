extends Node
class_name  slow_mo_node
var slow_motion_active:bool=false

@export var normal_time_scale:float=1.0
@export var slown_time_scale:float=1.0

func start_slow_motion()->void : 
	Engine.time_scale=slown_time_scale
	slow_motion_active=true
func stops_slow_motion()->void : 
	Engine.time_scale=normal_time_scale
	slow_motion_active=false
	
func request_slow_motion_change()->void:
	if !slow_motion_active : start_slow_motion()
	else : stops_slow_motion()
