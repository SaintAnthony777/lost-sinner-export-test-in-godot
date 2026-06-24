extends CharacterBody3D

class_name player_character
@export var current_level_played:Level

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025
@export var SPEED := 5.0
@export var JUMP_VELOCITY :=8.0

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
@onready var divine_dividers_consumption_dict:Dictionary ={
	"Screaming Silence":45.0,
	"Sundown":55.0,
	"World Strongest Man":65.0
}
@onready var grace_consumption_dict:Dictionary ={
	"Heavy Charge":1.0,
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
var is_aiming : bool = false
var is_locking : bool = false
var is_shouting:bool=false

##innervars
var player_move_direction : Vector3
var player_direction : Vector3
var current_target : enemy_root
var self_delta=.01

## Grace and Divine Dividers
var divine_divider_list : Array[String] = []
var grace_list : Array[String] = []

#var for chaos
var chosen_gift:String=""
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
var player_inventory:Inventory=Inventory.new()
var hammer:Inventory_Item=Inventory_Item.new()
var shield:Inventory_Item=Inventory_Item.new()
var last_picked_item:Inventory_Item=null

func _ready() -> void:
	print(chosen_gift)
	camera.h_offset=.7
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	character.inv_UI.given_inventory=player_inventory
	hammer.create_item(
		"The Hand of the Maestria",
		1,
		"The weapon wield by Maerlyn, the mother of all humans, said to be unbreakable, needs a godly amount of strength to be used at its peak. This hammer was said to choose a sinner as its new wielder once Maerlyn falls. The Story goes that this Hammer has no real magic despite its durability the only one who can say if it's true is no longer able to tell anything about it",
		true,
		"weapon"
	)
	shield.create_item(
		"Jack's Aegis",
		1,
		"This shield once belonged to the one they call the world's strongest man, it has the power to protect the one who uses it against everything that exists, a gift from Jack once he died, said to choose a sinner among the ones that remains. Jack made this shield by using his pure strength. in fact, it is said that Jack did never need to use a shield as he would bear with his body alone any hit that would land on him, the shield was meant to be a weapon to protect all of the humans, not him",
		true,
		"weapon"
	)
	if not shield in player_inventory.Inventory_list:
		player_inventory.add_item(shield,1)
		player_inventory.add_item(hammer,1)
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
			get_slide_collision(i).get_collider().apply_central_impulse(-get_slide_collision(i).get_normal()*2.0)
func camera_rotation_logic(delta:float):
	camera_controller.rotation.x+=camera_input_direction.y*delta
	camera_controller.rotation.x=clamp(camera_controller.rotation.x, -PI/6.0 , PI/3.0)
	camera_controller.rotation.y-=camera_input_direction.x*delta
	camera_input_direction=Vector2.ZERO
	

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

func get_best_target()->enemy_root:
	var best_target : enemy_root
	var min_angle = INF
	var enemies_in_sight=camera_area_of_sight.get_overlapping_bodies()
	for foe in enemies_in_sight :
		if foe is enemy_root:
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
	if camera_position=="left" : camera.h_offset=-.7 
	else : camera.h_offset=.7
	camera.v_offset=0.0
	can_switch_camera=true
	
func player_force_rotation()->void:
	var input_dir := Input.get_vector("Droite", "Gauche", "Bas", "Haut") 
	var look_pos = Vector3(self.current_target.aiming_node.global_position.x,
	self.global_position.y,
	self.current_target.global_position.z)
	if !character.is_taking_damage:
		self.character_moving(self.player_direction)
	self.character.locking_motion(input_dir)
	self.character.look_at(look_pos,Vector3.UP)

func camera_force_rotation(camera_offset_no_offense_here:float)->void:
	camera_offset_no_offense_here=self.global_position.distance_to(self.current_target.global_position)
	camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	var camera_look_pos =Vector3(self.current_target.global_position.x,
	self.camera_controller.global_position.y+camera_offset_no_offense_here,
	self.current_target.global_position.z)
	self.camera_controller.look_at(camera_look_pos,Vector3.UP)
	
func camera_and_mesh_rotation()->void:
	self.character.rotate_y(PI)
	self.camera_controller.rotate_y(PI)
