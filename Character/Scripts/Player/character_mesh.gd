extends Node3D

class_name character_mesh

var isrolling:bool=false
var is_sliding:bool=false
var is_backfliping:bool=false
var starts_backflips:bool=false
var is_shouting:bool=false
var is_sundowning:bool=false

var can_advance_to_next_atack_pattern:=false
var is_attacking:bool=false
var attack_lunge_boolean:=false
var is_making_dash_attack:=false
var requested_dash_attack:=false
var requested_sliding:=false
var requested_slide_attack=false

@onready var player: player_character = $".."

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	pass
func normal_motion(current_action:String)->void:
	grounding("Normal")
	animation_tree.set("parameters/Normal_Transition/transition_request",current_action)
func strafing_motion(direction:Vector2)->void:
	grounding("Aiming")
	animation_tree.set("parameters/Strafe_blendspace/blend_position",direction)
func locking_motion(direction:Vector2)->void:
	grounding("Locking")
	animation_tree.set("parameters/locking_blendspace/blend_position",direction)
func shield_motion(current_action:String,input_dir:Vector2):
	grounding("Ground shielding")
	animation_tree.set("parameters/Ground shield transistion/transition_request",current_action)
	animation_tree.set("parameters/Shield blendspace strafe/blend_position",input_dir)

func grounding(stance:String)->void:
	animation_tree.set("parameters/State/transition_request","Grounded")
	animation_tree.set("parameters/Ground_state/transition_request","Ground_Motion")
	animation_tree.set("parameters/Moving/transition_request",stance)

### Rolling and all that
func rolling()->void:
	grounding("Rolling")
	animation_tree.set("parameters/roll_transistion/transition_request","rolling")
func sliding()->void:
	grounding("Rolling")
	animation_tree.set("parameters/roll_transistion/transition_request","sliding")	
func backflip()->void:
	grounding("Rolling")
	animation_tree.set("parameters/roll_transistion/transition_request","backflip")
func sprinting()->void:
	grounding("Sprinting")


###Attack animation
func attacking(current_stance:String,current_weapon:String,current_action:String)->void:
	grounding("Ground Attacks")
	animation_tree.set('parameters/Ground Attack transitions/transition_request',current_stance)
	animation_tree.set('parameters/Weapon_equipped/transition_request',current_weapon)
	animation_tree.set('parameters/'+current_weapon+'_attack_transition/transition_request',current_weapon+"_"+current_action)

func special_attacks(current_action:String)->void:
	grounding("Ground Attacks")
	animation_tree.set('parameters/Ground Attack transitions/transition_request',"Specials")
	animation_tree.set('parameters/special attacks transitions/transition_request',current_action)
	
	
###combo logic by me
func cannot_progress_combo()->void: can_advance_to_next_atack_pattern=false
func can_progress_combo()->void: can_advance_to_next_atack_pattern=true

###NO signals so use vars xoxo
func done_rolling_func()->void:
	isrolling=false
func done_sliding()->void:
	is_sliding=false
	requested_sliding=false
func done_backflips()->void:
	is_backfliping=false
func done_shouting()->void:
	is_shouting=false
func done_sundowning()->void:
	is_sundowning=false

func done_attacking()->void:
	is_attacking=false
	requested_dash_attack=false

func starts_backflipping()->void:
	starts_backflips=true
func stops_backflipping()->void:
	starts_backflips=false

func start_lunging()->void:
	attack_lunge_boolean=true
func stops_lunging()->void:
	attack_lunge_boolean=false

func check_attack_lunge(lunge_speed:float)->void:
	if attack_lunge_boolean:
		var dashdirection=self.transform.basis.z.normalized()
		player.velocity=dashdirection*lunge_speed
		player.velocity.y=0
		player.move_and_slide()

func force_character_rotation():
	self.look_at(Vector3(player.looking_at_node.global_position.x,
	player.global_position.y,
	player.looking_at_node.global_position.z),Vector3.UP,true)

func starting_dash_attack()->void:
	is_making_dash_attack=true
func stopped_dash_attack()->void:
	is_making_dash_attack=false
