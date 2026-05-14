class_name regular_enemy extends enemy_root

@onready var aiming_node: Node3D = $"Aiming Node"
@onready var hurtbox:HurtBoxComponent=$HurtBoxComponent
@onready var health_comp:HealthComponent=$"HealthComponent"

###Damage vars
var Is_taking_hit:bool=false


func _ready() -> void:
	visuals=$Visuals
	health_comp.Moveable_Body=self
	initialize_player()
func death_function():
	queue_free()
