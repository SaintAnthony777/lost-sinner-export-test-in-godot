extends Node

func hit_stop_function(time_sacle_given:float)->void:
	Engine.time_scale=.01
	await get_tree().create_timer(time_sacle_given,true,false,true).timeout
	Engine.time_scale=1.0
