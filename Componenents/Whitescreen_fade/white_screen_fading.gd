class_name white_screen extends Control

@onready var white_screen_animator: AnimationPlayer = $white_screen_animator

func _ready() -> void :
	white_screen_animator.play("white_screen_animation")
	await white_screen_animator.animation_finished
	get_tree().change_scene_to_file("res://Componenents/Loading Screen/loading_screen.tscn")
