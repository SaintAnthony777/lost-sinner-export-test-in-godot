extends State

func physics_update(delta):
	owner.velocity.y -= owner.gravity * delta
	var input_dir:=Input.get_vector("Gauche","Droite","Haut","Bas")
	owner.velocity.x = move_toward(owner.velocity.x,input_dir.x*owner.SPEED,1.0)
	
	owner.move_and_slide()
	
	if owner.is_on_floor():
		transitioned.emit("On_Ground")
