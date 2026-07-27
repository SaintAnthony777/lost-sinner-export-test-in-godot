class_name EnemyVisuals extends Node3D

@onready var enemy_body: enemy_root = $".."
@onready var animation_tree: AnimationTree = $AnimationTree

@onready var attack_direction:String="left"
@onready var received_direction:String="ch"
var is_attacking:=false
var is_taking_damage:bool=false
var is_lunging:bool=false
var is_turning_at_player:bool=false
var is_ready:bool=false
var dealt_attack:Attack
var is_thinking:bool
var current_react_dir:String=""
var is_blocking:bool=false
var is_alive:bool=true

signal being_hit
signal died
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent
@export var projectile_spawn_point:Marker3D
func Grounding(current_state:String,current_action:String)->void:
	animation_tree.set('parameters/Final_State/transition_request',"Grounded")
	animation_tree.set("parameters/Ground Transisitons/transition_request",current_state)
	animation_tree.set('parameters/'+current_state+' transition/transition_request',current_action)
	
func taking_damage(reaction_dir:String)->void:
	animation_tree.set('parameters/Final_State/transition_request',"Grounded")
	animation_tree.set('parameters/Ground Transisitons/transition_request','React_'+reaction_dir)

func done_attacking()->void:
	is_attacking=false
func done_taking_damage()->void:
	is_taking_damage=false
	
func _process(delta: float) -> void:
	if !is_alive:
		died.emit()
func _on_being_hit() -> void:
	enemy_body.target.camera_shaking(.1,.1)
	print("la direction de l'attaque est ",received_direction)
	self.Grounding("Taking Damage","React "+received_direction.capitalize())
	await self.animation_tree.animation_finished
	self.Grounding("Still motion","Idle")
func _on_died() -> void:
	self.Grounding("Dying","Dying 2")
	await animation_tree.animation_finished
	enemy_body.queue_free()
	
func spawn_fireball_projectile(projectile_element:String)->void:
	var projectile_packed_scene:PackedScene=load("res://Componenents/projectiles/enemy/"+projectile_element+"_ball_enemy.tscn")
	var projectile_instance:enemy_projectile=projectile_packed_scene.instantiate()
	get_parent().owner.add_child(projectile_instance)
	if is_instance_valid(projectile_instance):
		projectile_instance.global_position=projectile_spawn_point.global_position
		projectile_instance.basis=projectile_spawn_point.basis
		projectile_instance.look_at(enemy_body.target.global_position)
