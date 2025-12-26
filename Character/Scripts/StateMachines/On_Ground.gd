extends State

var anim_tree = owner.get_node("AnimationTree").get("parameters/playback")

func physics_update(_delta):
	if not owner.is_on_floor():
		transitioned.emit("Airborne")
		return
	var input_dir := Input.get_vector("Gauche","Droite","Haut","Bas")
	if Input.is_action_pressed("Aiming"):
		handle_strafe(input_dir)
		anim_tree.travel("Idle")
	else :
		handle_normal_movement(input_dir)
		anim_tree.travel("Unarmed_Idle")
		
	owner.move_and_slide()

func handle_normal_movement(dir:Vector2):
	if dir :
		owner.velocity.x = dir.x * owner.SPEED
		owner.velocity.z = dir.y * owner.SPEED
		owner.character_mesh.look_at(owner.global_position + Vector3(dir.x,0,dir.y))
	
func handle_strafe(dir:Vector2):
	if owner.target:
		owner.look_at(owner.target.global_position)
	else :
		owner.look_at(Vector3(owner.aiming_node.global_position.x,0,owner.target.global_position.z))
	owner.velocity.x = dir.x * (owner.SPEED * 0.6)
	owner.velocity.z = dir.y * (owner.SPEED * 0.6)
	owner.animation_tree.set("parameters/Strafe/blend_position",dir)
	
	
