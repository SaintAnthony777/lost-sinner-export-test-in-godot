extends CharacterBody3D

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025
@export var SPEED := 7.0
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

###Various vars 
var strafe_direction:String

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
	
	## Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	## Sauts
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_impulse
		
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut")
	var forward:=camera.global_basis.z
	var right:=camera.global_basis.x
	var move_direction:=forward*input_dir.y*-1 + right*input_dir.x*-1
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move_direction.y = 0.0
	move_direction=move_direction.normalized()
	
	## Character_moves
	character_moving(direction)
	## rotation du personnage
	character_rotation(move_direction,last_movement_direction,delta,is_aiming)
	## Moves animation logic en d'autre termes 
	moves_logic(input_dir)
	##Smoothmoving par move and slide better test move and collide un jour
	move_and_slide()
	



###### Fonctions ICI ####
##Moves Logic here
func moves_logic(input_dir:Vector2):
	if is_aiming:
		strafing_motion_logic(velocity,input_dir)
	else : 
		normal_moves_logics(velocity)
#func ground moves logic here
func normal_moves_logics(vel:Vector3):
	var ground_speed=vel.length()
	if is_on_floor():
		if ground_speed >= 0.2 : character.normal_motion("Walk")
		else : character.normal_motion("Idle_unarmed")
	else:
		pass

###Strafing logic here
func strafing_motion_logic(vel:Vector3,input_dir:Vector2):
	if is_on_floor():
		character.strafing_motion(input_dir)
	else:
		pass

## La fonction permettant de faire tourner le personnage dans une direction
func character_rotation(move_dir:Vector3,last_mov_dir:Vector3,delta:float,aiming_stance:bool):
	if move_dir.length() > 0.2 and !aiming_stance:
		last_mov_dir=move_dir
		var target_angle:=Vector3.BACK.signed_angle_to(last_mov_dir,Vector3.UP)
		character.global_rotation.y=lerp_angle(character.rotation.y,target_angle,rotation_speed*delta)
	if aiming_stance:
		character.look_at(Vector3(looking_at_node.global_position.x,self.global_position.y,looking_at_node.global_position.z),Vector3.UP,true)
		
## Fonction permettant de déplacer le personnage
func character_moving(dir:Vector3):
	if is_aiming : SPEED = 3.0 
	else : SPEED = 7.0
	if dir:
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
## Stop motion pour effectuer des arrêts de physics
func stop_motion():
	velocity.x=0
	velocity.z=0

func camera_rotation_logic(delta:float,aiming_stance:bool):
	camera_controller.rotation.x+=camera_input_direction.y*delta
	camera_controller.rotation.x=clamp(camera_controller.rotation.x, -PI/6.0 , PI/3.0)
	camera_controller.rotation.y-=camera_input_direction.x*delta
	camera_input_direction=Vector2.ZERO
	if !aiming_stance:
		camera.fov=lerp(camera.fov,95.0,.15)
	else :
		camera.fov=lerp(camera.fov,75.0,.15)
		
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

### Fonction permettant de récuperer la direction de strafing:
func strafing_direction():
	if Input.is_action_pressed("Haut") : strafe_direction = "forward"
	if Input.is_action_pressed("Gauche") : strafe_direction = "left"
	if Input.is_action_pressed("Droite") : strafe_direction = "right"
	if Input.is_action_pressed("Bas") : strafe_direction = "backwards"
