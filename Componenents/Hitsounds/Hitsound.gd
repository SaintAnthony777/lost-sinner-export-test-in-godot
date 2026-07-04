class_name Hitsound_impact extends AudioStreamPlayer3D

@onready var hitsound_type:String

func load_sound():
	var hitsound_node:AudioStreamPlayer3D=AudioStreamPlayer3D.new()
	var hitsound_track:=load("res://Sounds/Effects/Impact_"+hitsound_type+".mp3")
	hitsound_node.stream=hitsound_track
	hitsound_node.pitch_scale=randf_range(.5,1.0)
	self.add_child(hitsound_node)
	hitsound_node.volume_db=-5.0
	hitsound_node.play()
	print("playing")
	await hitsound_node.finished
	self.queue_free()
