class_name EnemyVisuals extends Node3D

@onready var enemy_body: regular_enemy = $".."
@onready var animation_tree: AnimationTree = $AnimationTree

@onready var attack_direction:String="left"

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

@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent

func Grounding(current_action:String)->void:
	animation_tree.set('parameters/Final_State/transition_request',"Grounded")
	animation_tree.set("parameters/Ground Transisitons/transition_request",current_action)
func taking_damage(reaction_dir:String)->void:
	animation_tree.set('parameters/Final_State/transition_request',"Grounded")
	animation_tree.set('parameters/Ground Transisitons/transition_request','React_'+reaction_dir)

func done_attacking()->void:
	is_attacking=false
func done_taking_damage()->void:
	is_taking_damage=false
	
func _on_being_hit() -> void:
	enemy_body.target.camera_shaking(.1,.1)
	if enemy_body.target.character.attack_direction!=current_react_dir:
		current_react_dir=enemy_body.target.character.attack_direction
		self.taking_damage(current_react_dir)
