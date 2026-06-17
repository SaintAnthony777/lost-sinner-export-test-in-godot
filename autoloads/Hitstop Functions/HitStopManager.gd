extends Node

func hit_stop_function(time_sacle_given:float,duration:float)->void:
	Engine.time_scale=time_sacle_given
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale=1.0
