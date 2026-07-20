class_name Boss_Visuals extends EnemyVisuals


@onready var Boss_Body:Boss_Root=$"../"
@onready var sword_hitbox_component:HitBoxComponent=$"Armature/Skeleton3D/Hand Attachement/Golden Sword/HitBoxComponent"
@onready var AOE_hitbox:HitBoxComponent=$"AOE_HITBOX"



func Boss_motion(current_state:String,current_action:String)->void:
	animation_tree.set("parameters/Final Output Transition/transition_request",current_state)
	await get_tree().process_frame
	animation_tree.set("parameters/"+current_state+" Motion Transition/transition_request",current_action)

func is_ready_function():
	is_ready=true
	
	

func force_camera_shake(intensity:float,duration:float)->void:
	Boss_Body.target.camera_shaking(intensity,duration)

func spawn_screaming_particles()->void:
	var scream_part:=load("res://Componenents/screaming silence particles/screaming_silence_particles.tscn")
	var scream_part_inst:screaming_particles=scream_part.instantiate()
	self.add_child(scream_part_inst)
func spaww_impulse()->void:
	var impulse:=load("res://Componenents/Circular distorsion node/Circular distorsion.tscn")
	var impulse_node:circular_distorsion=impulse.instantiate()
	impulse_node.force=1.0
	impulse_node.given_center = (get_viewport().get_camera_3d().unproject_position(Boss_Body.aiming_node.global_position))
	self.add_child(impulse_node)
	
func spawn_distorsion()->void:
	var distorsion:=load("res://Componenents/Radial Blur componene/radial_blur_and_chromatic_aberration.tscn")
	var distorsion_node:RadialBlurPlusChromatic=distorsion.instantiate()
	distorsion_node.center_3d_given=Boss_Body.aiming_node.global_position
	self.add_child(distorsion_node)
