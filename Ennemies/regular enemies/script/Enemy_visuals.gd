class_name EnemyVisuals extends Node3D

@onready var enemy_body: regular_enemy = $".."
@onready var animation_tree: AnimationTree = $"../AnimationTree"

func Grounding(current_action:String)->void:
	animation_tree.set('parameters/Final_State/transition_request',"Grounded")
	animation_tree.set("parameters/Ground Transisitons/transition_request",current_action)
