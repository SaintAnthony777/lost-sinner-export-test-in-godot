class_name HurtBoxComponent extends Area3D

@export var health_comp:HealthComponent

func _init() -> void:
	collision_layer=5
	collision_mask=4
func _on_area_entered(area: Area3D) -> void:
	if area is HitBoxComponent and self.owner!=area.owner and area.untouchable_owner!=owner:
		print("attack from ",area.owner,"received by ",owner)
