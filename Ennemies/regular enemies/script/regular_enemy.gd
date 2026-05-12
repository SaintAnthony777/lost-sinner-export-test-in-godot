class_name regular_enemy extends enemy

@onready var aiming_node: Node3D = $"Aiming Node"
@onready var hurtbox:HurtBoxComponent=$HurtBoxComponent
@onready var health_comp:HealthComponent=$"HealthComponent"


func _ready() -> void:
	visuals=$Visuals
	health_comp.Moveable_Body=self
