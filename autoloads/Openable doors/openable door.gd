class_name Openable_Gate extends Node3D

@onready var gate_animation:AnimationPlayer=$"Door animation"
@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var opening_side:=""
@onready var opened:bool=false
@onready var player_pos:Marker3D=$Playerposition

func _process(delta: float) -> void:
	if opening_side!="" and !opened and Input.is_action_just_pressed("Action trigger") and !personnage.is_busy:
		opened=true
		for area in self.get_children():
			if area is interaction_area:
				area.disable_all_collsion()
			gate_animation.play("Open from "+opening_side)
	
func opened_door()->void:
	opened=true
