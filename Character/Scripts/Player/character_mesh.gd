extends Node3D

class_name character_mesh

var isrolling:bool=false
var is_sliding:bool=false
var is_backfliping:bool=false
var starts_backflips:bool=false
var is_shouting:bool=false
var can_advance_to_next_atack_pattern:=false

@onready var wing_mesh: MeshInstance3D = $"Armature/Skeleton3D/Wings_Attachement/Angel wings/Wing_Mesh"
@onready var rune_mesh: MeshInstance3D = $Feet_bursts/angel_burst_rune/rune_mesh

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

###NO signals so use vars xoxo
func done_rolling_func()->void:
	isrolling=false
func done_sliding()->void:
	is_sliding=false
func done_backflips()->void:
	is_backfliping=false
func done_shouting()->void:
	is_shouting=false

func starts_backflipping()->void:
	starts_backflips=true
func stops_backflipping()->void:
	starts_backflips=false
