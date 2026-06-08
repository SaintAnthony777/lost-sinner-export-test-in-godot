class_name arcane_component extends Node

@export var Max_Arcane:float
@export var Arcane_Gauge:TextureProgressBar

var current_arcane:float

func _ready() -> void:
	current_arcane=Max_Arcane
func _process(_delta: float) -> void:
	#Arcane_Gauge.value=current_arcane
	Arcane_Gauge.value=lerp(Arcane_Gauge.value,current_arcane,.5)
func arcane_consumption(current_attack:Attack)->void:
	current_arcane-=current_attack.arcane_consumption
	if current_arcane<0:
		current_arcane=0
