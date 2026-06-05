class_name fracturable_static extends StaticBody3D

@onready var is_alive:bool=true
@export var packed_breakable:PackedScene
@export var fracture_target:fracturable
@onready var health_comp:HealthComponent=$"HealthComponent"
@onready var spawn_point:Marker3D=$"Spawn Point"

func _ready() -> void:
	health_comp.random_node_to_call_on_death=self
func _physics_process(delta: float) -> void:
	if !is_alive:
		break_everything()
func break_everything()->void:
	var broken_instance: fracturable = packed_breakable.instantiate()
	owner.add_child(broken_instance)
	if health_comp.attack_sender:
		print(health_comp.attack_sender)
		broken_instance.Thrower_position=health_comp.attack_sender.global_position
	broken_instance.global_position=spawn_point.global_position
	broken_instance.breaker_baby()
	queue_free()
