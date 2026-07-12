class_name Boss_Visuals extends EnemyVisuals


@onready var Boss_Body:Boss_Root=$"../"
@onready var sword_hitbox_component:HitBoxComponent=$"Armature/Skeleton3D/Hand Attachement/Golden Sword/HitBoxComponent"
@onready var AOE_hitbox:HitBoxComponent=$"AOE_HITBOX"



func Boss_motion(current_state:String,current_action:String)->void:
	animation_tree.set("parameters/Final Output Transition/transition_request",current_state)
	animation_tree.set("parameters/"+current_state+" Motion Transition/transition_request",current_action)

func is_ready_function():
	is_ready=true
	
	

func force_camera_shake(intensity:float,duration:float)->void:
	Boss_Body.target.camera_shaking(intensity,duration)

func spawn_screaming_particles()->void:
	var scream_part:=load("res://Componenents/screaming silence particles/screaming_silence_particles.tscn")
	var scream_part_inst:screaming_particles=scream_part.instantiate()
	self.add_child(scream_part_inst)
