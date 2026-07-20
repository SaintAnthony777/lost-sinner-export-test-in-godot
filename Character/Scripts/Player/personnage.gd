extends CharacterBody3D

class_name player_character
@export var current_level_played:Level

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025
@export var SPEED := 5.0
@export var JUMP_VELOCITY :=8.0
@export var best_vertical_position:float
@export var best_horizontal_position:float
@export var max_separation:float

@onready var camera_controller: Node3D = %Camera_pivot
@onready var character: character_mesh = $"The Lost Sinner1"
@onready var camera: Camera3D = %Camera3D
@onready var camera_animations: AnimationPlayer = $Camera_animations
@onready var looking_at_node: Node3D = $"Camera_pivot/Looking at"
@onready var camera_area_of_sight: Area3D = $Camera_pivot/SpringArm3D/Camera_area_of_sight
@onready var camera_line_of_sight: RayCast3D = $Camera_pivot/SpringArm3D/Camera_line_of_sight
@onready var hammer_starting_point:Node3D=$"Camera_pivot/Hammer_throw_starter_point"
@onready var aiming_node:Node3D=$"Camera_pivot/Aiming"
@onready var state_mach:StateMachine=$"StateMachine"

@onready var current_item:RegenItem=RegenItem.new()
@onready var used_item:RegenItem=RegenItem.new()
@onready var max_fruits:int=0
@onready var max_seeds:int=0

@onready var spring_arm_3d: SpringArm3D = $Camera_pivot/SpringArm3D

@onready var divine_dividers_consumption_dict:Dictionary ={
	"Screaming Silence":45.0,
	"Sundown":55.0,
	"World Strongest Man":65.0
}
@onready var grace_consumption_dict:Dictionary ={
	"Heavy Charge":0.3,
	"Disordonance":35.0,
	"Disaster":45.0
}
###Camera Vars
var camera_input_direction := Vector2.ZERO
var last_movement_direction := Vector3.BACK
var rotation_speed := 6.0
var gravity := -25.0

var camera_position:String="right"
var can_switch_camera:bool=true
var is_camera_shaking:bool=false
var is_aiming : bool = false
var is_locking : bool = false
var is_shouting:bool=false
var po_look:Vector3

##innervars
var player_move_direction : Vector3
var player_direction : Vector3
var current_target : enemy_root
var self_delta=.01

## Grace and Divine Dividers
var divine_divider_list : Array[String] = []
var grace_list : Array[String] = []

#var for chaos
var chosen_gift:String="Fury of the Gods"
var gifts_unlocked:Array[String]

# var divine_divider_list : Array[String] = ["Sundown","Screaming Silence","World Strongest Man"]
# var grace_list : Array[String] = ["Disordonance","Heavy Charge","Disaster"]

var current_grace_index:=0
var current_divine_divider_index:=0
var current_divine_divider:=""
var current_grace:=""
var can_switch_special:=true

#Doors and all that
var can_interact:bool=false
var interaction_type:String=""
var marker_forced_pos:Marker3D=null
var player_look_node:Marker3D=null
var Interaction_side:String=""
var is_busy:bool=false

#var for save place locations
var save_location:String

# var for inventory
var player_inventory:Inventory=SaveManager.current_save.player_inventory
var hammer:Inventory_Item=Inventory_Item.new()
var shield:Inventory_Item=Inventory_Item.new()
var last_picked_item:Inventory_Item=null

func _ready() -> void:
	#spring_arm_init()
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	character.inv_UI.given_inventory=player_inventory
	if divine_divider_list:
		current_divine_divider = divine_divider_list[current_divine_divider_index]
	if grace_list : 
		current_grace = grace_list[current_grace_index]
	for element in player_inventory.Inventory_list:
			if element and element is Inventory_Item:
				if element.category == "divine divider":
					divine_divider_list.append(element.item_name)
				if element.category == "grace":
					grace_list.append(element.item_name)
		
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Camera Switching") and can_switch_camera:
		camera_switch_logic()
	if Input.is_action_just_pressed("Grace switch") and can_switch_special:
		switch_special(grace_list)
	if Input.is_action_just_pressed("Divine Divider switch") and can_switch_special:
		switch_special(divine_divider_list)
	

func _unhandled_input(event: InputEvent) -> void:
	var camera_is_in_motion:=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
		)
	if camera_is_in_motion:
		camera_input_direction=event.screen_relative*mouse_sensitivity
	
func _physics_process(_delta: float) -> void:
	adapt_camera(_delta)
	SimpleGrass.set_player_position(global_position)
	if divine_divider_list :
		current_divine_divider = divine_divider_list[current_divine_divider_index]
	if grace_list :
		current_grace = grace_list[current_grace_index]
	if !current_target or !is_locking:
		current_target=get_best_target()
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut").normalized()
	var forward:=camera.global_basis.z
	var right:=camera.global_basis.x
	var move_direction:=forward*input_dir.y*-1 + right*input_dir.x*-1
	move_direction.y = 0.0
	if move_direction.length()>0.001 : move_direction.normalized()
	player_move_direction=move_direction
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y=0
	if direction.length() > 0.001: direction.normalized()
	player_direction=direction
	if is_busy:can_interact=false

## Fonction permettant de déplacer le personnage
func character_moving(dir:Vector3):
	dir.y=0
	dir=dir.normalized()
	if dir:
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	push_rigids()
	
func push_rigids()->void:
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() is RigidBody3D:
			get_slide_collision(i).get_collider().apply_central_impulse(-get_slide_collision(i).get_normal()*1.0)

func camera_rotation_logic(delta:float):
	camera_controller.rotation.x+=camera_input_direction.y*delta
	camera_controller.rotation.x=clamp(camera_controller.rotation.x, -PI/6.0 , PI/3.0)
	camera_controller.rotation.y-=camera_input_direction.x*delta
	camera_input_direction=Vector2.ZERO
	

###fonction permettant de faire du va et viens entre gauche droite de la camera
func camera_switch_logic():
	can_switch_camera=false
	if camera_position=="left":
		camera_animations.play("Camera_switching_To_Right")
		await camera_animations.animation_finished
		camera_position="right"
	else:
		camera_animations.play("Camera_switching_to_Left")
		await camera_animations.animation_finished
		camera_position="left"
	can_switch_camera=true

func get_best_target()->enemy_root:
	var best_target : enemy_root
	var min_angle = INF
	var enemies_in_sight=camera_area_of_sight.get_overlapping_bodies()
	for foe in enemies_in_sight :
		if foe is enemy_root and foe.visuals.is_alive:
			camera_line_of_sight.look_at(foe.aiming_node.global_position)
			camera_line_of_sight.force_raycast_update()
			if camera_line_of_sight.is_colliding() and camera_line_of_sight.get_collider() is enemy_root:
				var direction_to_enemy = (foe.global_position-self.global_position).normalized()
				var camera_forward := -camera.global_basis.z
				var angle = camera_forward.angle_to(direction_to_enemy)
				if angle < min_angle:
					min_angle = angle
					best_target=foe
	return best_target

func gravity_applying(delta)->void:
	if !is_on_floor() : velocity.y+=gravity*delta

func character_rotation(move_dir:Vector3,last_mov_dir:Vector3,delta:float):
	if move_dir.length() > 0.2 :
		last_mov_dir=move_dir
		var target_angle := Vector3.BACK.signed_angle_to(last_mov_dir,Vector3.UP)
		character.global_rotation.y=lerp_angle(character.rotation.y,target_angle,rotation_speed*delta)


func get_target_point()->Vector3:
	var center := get_viewport().get_visible_rect().size / 2
	var from := camera.project_ray_origin(center)
	var to := from + camera.project_ray_normal(center) * 100
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from,to)
	var result := space_state.intersect_ray(query)
	if result: return result.position
	else : return to

func jumping()->void:
	velocity.y += 0.0
	move_and_slide()

func switch_special(special_to_be_switched_list:Array)->void:
	can_switch_special=false
	if special_to_be_switched_list==grace_list:
		current_grace_index+=1
		if current_grace_index>=grace_list.size():
			current_grace_index=0
		character.hud_animation_player.play("Grace Switch")
	elif special_to_be_switched_list==divine_divider_list:
		current_divine_divider_index+=1
		if current_divine_divider_index>=divine_divider_list.size():
			current_divine_divider_index=0
		character.hud_animation_player.play("Divine_divider_switch")
	await character.hud_animation_player.animation_finished
	can_switch_special=true
	
func reset_camera()->void:
	if camera_position=="left" : camera.h_offset=-.25 
	else : camera.h_offset=.25
	camera.v_offset=0.0
	can_switch_camera=true
	
func player_force_rotation()->void:
	if !self.current_target: return
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut") 
	var look_pos = Vector3(self.current_target.aiming_node.global_position.x,
	self.global_position.y,
	self.current_target.global_position.z)
	if !character.is_taking_damage:
		self.character_moving(self.player_direction)
	self.character.locking_motion(input_dir)
	self.character.look_at(look_pos,Vector3.UP)

func camera_force_rotation(camera_offset_no_offense_here:float)->void:
	if !self.current_target: return
	camera_offset_no_offense_here=self.global_position.distance_to(self.current_target.global_position)
	camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	var camera_look_pos =Vector3(self.current_target.global_position.x,
	self.camera_controller.global_position.y+camera_offset_no_offense_here,
	self.current_target.global_position.z)
	self.camera_controller.look_at(camera_look_pos,Vector3.UP)
	
func camera_and_mesh_rotation()->void:
	self.character.rotate_y(PI)
	self.camera_controller.rotate_y(PI)

func camera_shaking(max_rotation_degrees:float,duration:float)->void:
	if is_camera_shaking : return
	is_camera_shaking = true
	
	var max_rotation:=deg_to_rad(max_rotation_degrees)
	var time_left:=duration
	var rotation_start:=camera.rotation
	
	while time_left > 0 :
		var offset_x = randf_range(-max_rotation,max_rotation)
		var offset_y = randf_range(-max_rotation,max_rotation)
		
		camera.rotation.x = rotation_start.x + offset_x
		camera.rotation.y = rotation_start.y + offset_y
		
		time_left-=get_process_delta_time()
		await get_tree().process_frame
		if not is_instance_valid(self) or not is_inside_tree():
			return
		#rotation_start.x = camera.rotation.x - offset_x
		rotation_start.y = camera.rotation.y -offset_y
		
	camera.rotation = rotation_start
	is_camera_shaking=false
		
func nullyfying_velocity(delta:float)->void:
	self.velocity.x=lerp(self.velocity.x,0.0,delta*10)
	self.velocity.z=lerp(self.velocity.z,0.0,delta*10)
	
func adapt_camera(delta)->void:
	##offset
	var ratio:float=spring_arm_3d.get_hit_length()
	var cam_pos:float
	if character.is_divine_dividing or character.is_making_grace:
		cam_pos=0.0
	else :
		if camera_position=="left":
			cam_pos=-0.25
		elif camera_position=="right" :
			cam_pos=.25
	var target_offset:float=cam_pos*ratio
	camera.h_offset=lerp(camera.h_offset,target_offset,.1)
	##position spring_arm
	#var current_length : float = spring_arm_3d.get_hit_length()
	#var ratio : float = current_length / max_separation
	#var target_x := best_horizontal_position * ratio
	##target_x = -target_x if camera_position=="left" else target_x
	#spring_arm_3d.position.x=lerp(spring_arm_3d.position.x,target_x,15.0*delta)
	
func spring_arm_init()->void:
	spring_arm_3d.spring_length=max_separation
	spring_arm_3d.margin = .2
	
func aim_at_center()->void:
		character.look_at(Vector3(self.get_target_point().x,self.global_position.y,self.get_target_point().z))
	
