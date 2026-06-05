extends Node3D

func _ready() -> void:
	SimpleGrass.set_interactive(true)
	for child in self.get_children():
		print(child)
