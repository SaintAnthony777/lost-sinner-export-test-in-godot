extends Node3D

@onready var hammer_ray_cast: RayCast3D = $Hammer_ray_cast

const HAMMER_SPEED:=40.0
var lifetime:=0.0
var returning:bool=false
func _process(delta: float) -> void:
	lifetime+=delta
	if !returning:
		global_position+=transform.basis*Vector3(0,0,HAMMER_SPEED)*delta
		if hammer_ray_cast.is_colliding() or lifetime > 1.0:
			print(hammer_ray_cast.get_collider())
			returning=true
	else :
		var direction = (get_parent().get_node("Personnage").hammer_starting_point.global_position-global_position).normalized()
		global_position+=direction*HAMMER_SPEED*delta
		rotate_y(20*delta)
		if global_position.distance_to(get_parent().get_node("Personnage").global_position)<3.0:
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").equipped_hammer.show()
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").pick_back_hammer=true
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").hammer_last_pos=self.global_position
			queue_free()
