class_name regular_enemy extends enemy_root

@onready var hurtbox:HurtBoxComponent=$HurtBoxComponent
@onready var health_comp:HealthComponent=$"HealthComponent"

###Damage vars
var Is_taking_hit:bool=false
var current_react_dir:String=""

##being hit signal
signal being_hit

func _ready() -> void:
	visuals=$Visuals
	health_comp.Moveable_Body=self
	initialize_player()
	initialize_aiming_node()
func death_function():
	queue_free()


func _on_being_hit() -> void:
	self.target.camera_shaking(.1,1.0)
	if self.target.character.attack_direction!=current_react_dir:
		current_react_dir=self.target.character.attack_direction
		visuals.taking_damage(current_react_dir)
