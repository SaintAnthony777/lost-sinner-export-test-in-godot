extends CharacterBody3D

class_name player_character

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025
@export var SPEED := 5.0
@export var JUMP_VELOCITY :=8.0

@onready var camera_controller: Node3D = %Camera_pivot
@onready var character: character_mesh = $"The Lost Sinner1"
@onready var camera: Camera3D = %Camera3D
@onready var camera_animations: AnimationPlayer = $Camera_animations
@onready var looking_at_node: Node3D = $"Camera_pivot/Looking at"

###Camera Vars
var camera_input_direction:=Vector2.ZERO
var last_movement_direction:=Vector3.BACK
var rotation_speed:=6.0
var gravity:=-19.0
var jump_impulse:=8.0
var start_jumping:=false
var camera_position:String="left"
var can_switch_camera:bool
var is_aiming:bool=false

##innervars
var player_move_direction:Vector3

func _ready() -> void:
	pass
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("left click"):
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("Pause"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("Camera Switching"):
		camera_switch_logic()
	if Input.is_action_pressed("Aiming"):
		is_aiming=true
	if Input.is_action_just_released("Aiming"):
		is_aiming=false

func _unhandled_input(event: InputEvent) -> void:
	var camera_is_in_motion:=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
		)
	if camera_is_in_motion:
		camera_input_direction=event.screen_relative*mouse_sensitivity

func _physics_process(delta: float) -> void:
	## Faire en sorte que la fonction de rotation de la camera passe avant tout
	camera_rotation_logic(delta,is_aiming)
	
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut").normalized()
	var forward:=camera.global_basis.z
	var right:=camera.global_basis.x
	var move_direction:=forward*input_dir.y*-1 + right*input_dir.x*-1
	player_move_direction=move_direction
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move_direction.y = 0.0
	move_direction=move_direction.normalized()
	
	## Character_moves
	character_moving(direction)
	move_and_slide()

## Fonction permettant de déplacer le personnage
func character_moving(dir:Vector3):
	if dir:
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func camera_rotation_logic(delta:float,aiming_stance:bool):
	camera_controller.rotation.x+=camera_input_direction.y*delta
	camera_controller.rotation.x=clamp(camera_controller.rotation.x, -PI/6.0 , PI/3.0)
	camera_controller.rotation.y-=camera_input_direction.x*delta
	camera_input_direction=Vector2.ZERO
	if !aiming_stance:
		camera.fov=lerp(camera.fov,75.0,.15)
	else :
		camera.fov=lerp(camera.fov,55.0,.15)
		
###fonction permettant de faire du va et viens entre gauche droite de la camera
func camera_switch_logic():
	if camera_position=="left":
		camera_animations.play("Camera_switching_To_Right")
		await camera_animations.animation_finished
		camera_position="right"
	else:
		camera_animations.play("Camera_switching_to_Left")
		await camera_animations.animation_finished
		camera_position="left"
