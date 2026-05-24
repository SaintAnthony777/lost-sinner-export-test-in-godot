extends Node3D

class_name character_mesh

var isrolling:bool=false
var is_sliding:bool=false
var is_backfliping:bool=false
var starts_backflips:bool=false
var is_shouting:bool=false
var is_sundowning:bool=false
var is_divine_dividing:=false
var is_making_grace:=false
var landed:=false
var aerial_dashing:=false
var is_blocking:=false

var can_advance_to_next_atack_pattern:=false
var is_attacking:bool=false
var attack_lunge_boolean:=false
var is_making_dash_attack:=false
var requested_dash_attack:=false
var requested_sliding:=false
var requested_next_attack:=false
var requested_slide_attack=false
var requested_dash:=false
var can_throw_hammer:=true
var thrown_hammer:=false
var pick_back_hammer:=false
var hammer_last_pos:=Vector3.ZERO
var air_rises:=false
var air_stationary:=false
var air_lashes:=false
var can_unleash_heavy_charge:=false
var stopped_charging:=false
var can_unleash_divine_divider:=false
var is_taking_damage:bool=false
var is_alive:bool=true

@onready var player: player_character = $".."
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var slow_mo:slow_mo_node=$"slow_mo_node"

@onready var equipped_hammer=$"Armature/Skeleton3D/Right_hand_weapon_attachment"
@onready var crosshair_layer: CanvasLayer = $CrosshairLayer
@onready var crosshair:Control=$"CrosshairLayer/Crosshair"
@onready var radial_blur_chomatic_color_rect:Control=$"Special effects layer/Radial Blur + Chromatic aberration/ColorRect"
@onready var hud_animation_player: AnimationPlayer = $"Hud canvas layer/HUD/AnimationPlayer"

@onready var heavy_charge_ray_cast: RayCast3D = $"Heavy Charge Ray cast"
@onready var hit_box_component: HitBoxComponent = $"Armature/Skeleton3D/Right_hand_weapon_attachment/Premier modèle/Hammer Hitbox"
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var hitbox_collision: CollisionShape3D = $"Armature/Skeleton3D/Right_hand_weapon_attachment/Premier modèle/Hammer Hitbox/CollisionShape3D"
@onready var arcane_component: arcane_component = $"Hud canvas layer/HUD/Health and equip/arcane_component"
@onready var AOE_hitBox:HitBoxComponent=$"AOE_Hitboxes/HitBoxComponent"
@onready var AOE_Collision:CollisionShape3D=$"AOE_Hitboxes/HitBoxComponent/CollisionShape3D"
@onready var health_component: HealthComponent = $"Hud canvas layer/HUD/Health and equip/HealthComponent"
@onready var dealt_attack:Attack

func _ready() -> void:
	health_component.Moveable_Player=player
	health_component.Armor_value=50
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

func taking_damage(damage_lift:String)->void:
	animation_tree.set("parameters/Ground_state/transition_request","Ground_Taking_Damage")
	animation_tree.set("parameters/Ground_Taking_Damage_transitions/transition_request",damage_lift+" Damage")

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

func special_attacks(current_state:String,current_action:String)->void:
	grounding("Ground Attacks")
	animation_tree.set('parameters/Ground Attack transitions/transition_request',current_state)
	animation_tree.set('parameters/'+current_state+' transitions/transition_request',current_action)
	
func aiming_attack(current_action:String):
	grounding("Ground Attacks")
	animation_tree.set('parameters/Ground Attack transitions/transition_request',"Aiming")
	animation_tree.set("parameters/aiming attack transition/transition_request",current_action)
	
###Air Logics 
func jump_logics(current_state:String,current_action:String):
	animation_tree.set("parameters/State/transition_request","Airborne")
	animation_tree.set("parameters/Airborne transition/transition_request",current_state)
	animation_tree.set("parameters/"+current_state+" Airborne Transitions/transition_request",current_action)
	
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

func done_divided()->void:
	is_divine_dividing=false
func done_gracing()->void:
	is_making_grace=false

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
	
func adjust_character_rotation(delta)->void:
	if player.player_move_direction!=Vector3.ZERO:
		player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	else :
		if player.current_target:
			self.look_at(Vector3(
				player.current_target.global_position.x,
				player.global_position.y,
				player.current_target.global_position.z
			))
		else:
			self.look_at(Vector3(
				player.get_target_point().x,
				player.global_position.y,
				player.get_target_point().z
			))
		self.rotate_y(PI)

func starting_dash_attack()->void:
	is_making_dash_attack=true
func stopped_dash_attack()->void:
	is_making_dash_attack=false

func has_thrown_hammer():
	can_throw_hammer=false
	thrown_hammer=true

func show_hammer():
	equipped_hammer.show()
	
func has_got_hammer_back():
	can_throw_hammer=true
	pick_back_hammer=false

func done_landing()->void:
	landed=true
func done_aerial_dash()->void:
	aerial_dashing=false

func starts_rising():
	air_rises=true
func stops_rising():
	air_rises=false
	air_stationary=true
func lashes_downward():
	air_stationary=false
	air_lashes=true
func done_lashing():
	air_lashes=false
func can_unleash_heavy_charge_now():
	can_unleash_heavy_charge=true
func stopped_heavy_charge():
	stopped_charging=true

func done_taking_damage()->void:
	is_taking_damage=false

func can_unleash_divine_divider_now():
	can_unleash_divine_divider=true

func roll_hurt_box_disable()->void:
	hurt_box_component.collision_shape.disabled=true
func roll_hurtbox_enable()->void:
	hurt_box_component.collision_shape.disabled=false
