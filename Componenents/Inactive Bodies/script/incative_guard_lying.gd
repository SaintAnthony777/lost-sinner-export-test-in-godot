class_name Inactivebody extends StaticBody3D
@export var animation : String
@onready var animation_player: AnimationPlayer = $"guard axed/AnimationPlayer"

func _ready() -> void:
	animation_player.play(animation)
