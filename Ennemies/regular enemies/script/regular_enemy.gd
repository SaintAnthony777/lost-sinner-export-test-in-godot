class_name regular_enemy extends enemy_root


###Damage vars
var Is_taking_hit:bool=false
var current_react_dir:String=""

##being hit signal
signal being_hit

func _ready() -> void:
	initialize_player()
	initialize_aiming_node()
	
func death_function():
	queue_free()


func _on_being_hit() -> void:
	self.target.camera_shaking(.1,.1)
	if self.target.character.attack_direction!=current_react_dir:
		print('going on')
		current_react_dir=self.target.character.attack_direction
		visuals.taking_damage(current_react_dir)
func is_target_in_range()->bool:
	if self.global_position.distance_to(target.global_position)<=attack_range:
		return true
	return false
func _on_refined_magus_died() -> void:
	pass # Replace with function body.
