class_name HurtBoxComponent extends Area3D

@export var health_comp:HealthComponent

func _on_area_entered(area: Area3D) -> void:
	print(area)
