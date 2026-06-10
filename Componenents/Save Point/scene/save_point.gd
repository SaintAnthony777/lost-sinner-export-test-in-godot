class_name SavePoint
extends Node3D

@export var save_place_name:String

@onready var interacted:bool=false
@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var inter_area:interaction_area=$interaction_area
func _process(delta: float) -> void:
	if !interacted and Input.is_action_just_pressed("Action trigger") and !personnage.is_busy and inter_area.interact==self:
		interacted=true
		for area in self.get_children():
			if area is interaction_area:
				area.disable_all_collsion()
	if !personnage.is_busy:
		interacted=false
		for area in self.get_children():
			if area is interaction_area:
				area.enable_all_collision()
