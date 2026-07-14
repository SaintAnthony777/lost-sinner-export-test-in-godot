class_name fracturable_rigid extends RigidBody3D

@onready var is_alive:bool=true
@export var packed_breakable:PackedScene

@onready var health_comp:HealthComponent=$"HealthComponent"
@onready var spawn_point:Marker3D=$"Spawn Point"
@onready var breakable_id:String=String(get_path())

func _ready() -> void:
	
	if breakable_id in SaveManager.current_save.props_id_list:
		queue_free()
		
func _physics_process(_delta: float) -> void:
	if !is_alive:
		if not breakable_id in SaveManager.current_save.props_id_list:
			SaveManager.current_save.props_id_list.append(breakable_id)
		break_everything()
	
func break_everything()->void:
	var broken_instance: fracturable = packed_breakable.instantiate()
	owner.add_child(broken_instance)
	if health_comp.attack_sender:
		broken_instance.Thrower_position=health_comp.attack_sender.global_position
	broken_instance.global_position=spawn_point.global_position
	broken_instance.rotation=self.rotation
	broken_instance.scale=scale
	broken_instance.breaker_baby()
	queue_free()
