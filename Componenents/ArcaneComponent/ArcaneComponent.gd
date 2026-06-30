class_name arcane_component extends Node

@export var Max_Arcane:float
@export var Arcane_Gauge:TextureProgressBar

var current_arcane:float

func _ready() -> void:
	current_arcane=Max_Arcane
func _process(_delta: float) -> void:
	#Arcane_Gauge.value=current_arcane
	Arcane_Gauge.value=lerp(Arcane_Gauge.value,current_arcane,.5)
	if current_arcane>=Max_Arcane:current_arcane=Max_Arcane
func arcane_consumption(current_attack:Attack)->void:
	current_arcane-=(current_attack.arcane_consumption)*Engine.time_scale
	if current_arcane<0:
		current_arcane=0
		
func regen_arcane(arcane_regained:float)->void:
	current_arcane+=arcane_regained
	if current_arcane>Max_Arcane:current_arcane=Max_Arcane
