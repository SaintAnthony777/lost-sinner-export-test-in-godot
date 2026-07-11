class_name HitBoxComponent extends Area3D

var untouchable_owner:Node3D
@onready var collsion_shape:CollisionShape3D=get_node("CollisionShape3D")

func _init() -> void:
	collision_layer=4
	collision_mask=5

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	collsion_shape.disabled=true
	
func _on_area_entered(area:Area3D) -> void:
	if area is HurtBoxComponent and area.owner!=self.owner:
		pass
