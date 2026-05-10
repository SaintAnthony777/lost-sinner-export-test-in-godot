class_name HitBoxComponent extends Area3D

var untouchable_owner:Node3D

func _init() -> void:
	collision_layer=4
	collision_mask=5
	
func _on_area_entered(area:Area3D) -> void:
	if area is HurtBoxComponent and owner!=self.owner:
		print(self.owner)
