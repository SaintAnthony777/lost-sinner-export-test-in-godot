extends CharacterBody3D

@onready var camera_pivot := $Camera_pivot
var sensitivity = 0.3

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.is_action_pressed("Aiming"):
			rotate_y(deg_to_rad(-event.relative.y*sensitivity))
		else :
			camera_pivot.rotate_y(deg_to_rad(-event.relative.x*sensitivity))
		camera_pivot.rotate_x(deg_to_rad(-event.relative.y*sensitivity))
		camera_pivot.rotation.x=clamp(camera_pivot.rotation.x,deg_to_rad(-60),deg_to_rad(60))
