class_name location_teller extends Control

@onready var label: Label = $MarginContainer/Label
@onready var animation_player_node: AnimationPlayer = $Animation_player_node
func _ready() -> void:
	animation_player_node.play("fade_animation")
