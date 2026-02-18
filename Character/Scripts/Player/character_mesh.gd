extends Node3D

class_name character_mesh

var isrolling:bool=false
var is_sliding:bool=false
var is_backfliping:bool=false
var starts_backflips:bool=false
var is_shouting:bool=false

@onready var wing_mesh: MeshInstance3D = $"Armature/Skeleton3D/Wings_Attachement/Angel wings/Wing_Mesh"
@onready var rune_mesh: MeshInstance3D = $Feet_bursts/angel_burst_rune/rune_mesh

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	pass
	props_preload()
func normal_motion(current_action:String)->void:
	grounding("Normal")
	animation_tree.set("parameters/Normal_Transition/transition_request",current_action)
func strafing_motion(direction:Vector2)->void:
	grounding("Aiming")
	animation_tree.set("parameters/Strafe_blendspace/blend_position",direction)
func locking_motion(direction:Vector2)->void:
	grounding("Locking")
	animation_tree.set("parameters/locking_blendspace/blend_position",direction)

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

func Shouting()->void:
	grounding("Ground Attacks")
	animation_tree.set('parameters/Ground Attack transitions/transition_request','Hand')
	animation_tree.set('parameters/Hand transitions/transition_request',"Burst attack")

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


func props_preload()->void:
	wing_mesh.show()
	wing_mesh.hide()
	rune_mesh.show()
	rune_mesh.hide()
	
