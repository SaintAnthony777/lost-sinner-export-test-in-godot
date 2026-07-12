extends Node3D

class_name character_mesh

signal being_hit

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

var opening_door:bool=false
var interacts:bool=false

var current_attack_nature : String = ""

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
@onready var arc_component: arcane_component = $"Hud canvas layer/HUD/Health and equip/arcane_component"
@onready var AOE_hitBox:HitBoxComponent=$"AOE_Hitboxes/HitBoxComponent"
@onready var AOE_Collision:CollisionShape3D=$"AOE_Hitboxes/HitBoxComponent/CollisionShape3D"
@onready var health_component: HealthComponent = $HealthComponent

@onready var gift_component: GiftComponent = $"Hud canvas layer/HUD/Health and equip/GiftComponent"

@onready var dealt_attack:Attack
@onready var Shield_Light:SpotLight3D=$"Shield Light"
@onready var inv_UI:inventory_UI=$"Inventory layer/Inventory"
@onready var unused_weapon_attachment: BoneAttachment3D = $Armature/Skeleton3D/Unused_weapon_attachment
@onready var right_hand_weapon_attachment: BoneAttachment3D = $Armature/Skeleton3D/Right_hand_weapon_attachment
@onready var item_picked_panel_shower: Control = $"Item_picked cavans layer/Item_picked panel shower"
@onready var Container_for_the_items: VBoxContainer = $"Item_picked cavans layer/Item_picked panel shower/Container/VBoxContainer"
@onready var right_hand_fruit: BoneAttachment3D = $Armature/Skeleton3D/Right_Hand_fruit

@onready var fire_of_giants_aura: Node3D = $"Aura effects/Fire of Giants Aura"
@onready var fury_of_the_gods_aura: Node3D = $"Aura effects/Fury of the Gods Aura"
@onready var Aura_list:Node3D=$"Aura effects"

@onready var is_healing:bool=false
@onready var healing_particles: Node3D = $"Healing particles"

@onready var distorsion_rectangle:PackedScene=preload("res://Componenents/Circular distorsion node/Circular distorsion.tscn")

@onready var hammer_sweep: AudioStreamPlayer3D = $"Armature/Skeleton3D/Hammer Sounds/Hammer Sweep"

@onready var passive_gift_sounds: BoneAttachment3D = $"Armature/Skeleton3D/Passive Gift Sounds"
@onready var footsteps_1: AudioStreamPlayer3D = $"Footsteps sounds/footsteps 1"

@onready var wind_trails_2: Node3D = $"Special effects/Wind trails 2"
@onready var thrust_forward_mesh: Node3D = $"Special effects/Thrust forward mesh"

@onready var attack_direction:String="left"

func _ready() -> void:
	health_component.Moveable_Player=player
	Shield_Light.hide()
	
func _process(delta: float) -> void:
	play_passive_gift_sound()
	
func show_equipped_weapon()->void:
	right_hand_weapon_attachment.show()
	unused_weapon_attachment.hide()

func hide_equipped_weapon()->void:
	right_hand_weapon_attachment.hide()
	unused_weapon_attachment.show()

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

func interaction_motion(current_action)->void:
	grounding("Interacts")
	animation_tree.set("parameters/Interaction Transition/transition_request",current_action)

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
func enchants(current_enchantement:String)->void:
	grounding("Enchants")
	animation_tree.set("parameters/Enchanting transition/transition_request",current_enchantement)

### healing functions with objects
func use_regen_Item(anim_name:String)->void:
	grounding("Use Object")
	animation_tree.set("parameters/Object Using Transistion/transition_request",anim_name)

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

func check_attack_lunge(lunge_speed:float,delta:float)->void:
	if attack_lunge_boolean:
		var dashdirection=self.transform.basis.z.normalized()
		player.velocity.x=dashdirection.x*lunge_speed
		player.velocity.z=dashdirection.z*lunge_speed
		player.gravity_applying(delta)
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

func force_lock_rotation()->void:
	if !player.current_target:player.is_locking=false; return
	if !player.current_target.is_alive: player.is_locking=false; return
	self.look_at(Vector3(
				player.current_target.global_position.x,
				player.global_position.y,
				player.current_target.global_position.z
			))
	self.rotate_y(PI)


func starting_dash_attack()->void:
	is_making_dash_attack=true
func stopped_dash_attack()->void:
	is_making_dash_attack=false

func has_thrown_hammer():
	#hide_equipped_weapon()
	unused_weapon_attachment.hide()
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

func done_opening_door()->void:
	opening_door=false
func done_interacting()->void:
	interacts=false
func can_unleash_divine_divider_now():
	can_unleash_divine_divider=true
	
func iframes_on()->void:
	health_component.is_invulnerable=true
func iframes_off()->void:
	health_component.is_invulnerable=false
	
func fruit_switch()->void:
	right_hand_fruit.visible=!right_hand_fruit.visible

func get_aura_by_gift(given_gift:String)->Aura:
	var aura_to_be_returned:Aura
	for aura : Aura in Aura_list.get_children():
		if aura :
			if aura.gift==given_gift:
				aura_to_be_returned=aura
	return aura_to_be_returned

func get_weapon_by_gift(given_gift:String)->Weapon:
	var weapon_to_be_returned:Weapon
	for weap : Weapon in right_hand_weapon_attachment.get_children():
		if weap and weap.weapon_s_gift==given_gift:
			weapon_to_be_returned = weap
	return weapon_to_be_returned
	
func emptied_enchantement()->void:
	for weap : Weapon in right_hand_weapon_attachment.get_children():
		if weap.weapon_s_gift!="Neutral":weap.hide()
		else : weap.show()
		
func switch_to_enchantement()->void:
	gift_component.is_consummed=true
	for weap : Weapon in right_hand_weapon_attachment.get_children():
		if weap.weapon_s_gift==player.chosen_gift : 
			weap.show()
			var dist:circular_distorsion=distorsion_rectangle.instantiate()
			dist.force=.1
			dist.thickness=2.0
			dist.given_center=player.camera.unproject_position(weap.global_position)
			self.add_child(dist)
			HitStopManager.hit_stop_function(.5,1.0)
		else : weap.hide()

func healing_factor(item_healer:RegenItem) -> void:
	if item_healer.regen_type=="health":
		health_component.Current_health+=item_healer.regen_value
	elif item_healer.regen_type=="arcane":
		arc_component.current_arcane+=item_healer.regen_value
		
func heals_now()->void:
	is_healing=true

func play_hammer_sweep()->void:
	hammer_sweep.pitch_scale=randf_range(.6,1.2)
	hammer_sweep.play()
func stop_hammer_sweep()->void:
	hammer_sweep.stop()

func play_passive_gift_sound():
	for sounds : AudioStreamPlayer3D in passive_gift_sounds.get_children():
		if sounds.name==player.chosen_gift and gift_component.is_consummed and !sounds.playing: 
			sounds.play()
		if !gift_component.is_consummed : sounds.stop()
	
func play_footsteps()->void:
	footsteps_1.pitch_scale=randf_range(1.0,1.2)
	footsteps_1.play()

func player_shaking_camera(max_rotation:float,duration:float)->void:
	player.camera_shaking(max_rotation,duration)

func scream_like_a_giant()->void:
	var scream_part:=load("res://Componenents/screaming silence particles/screaming_silence_particles.tscn")
	var scream_part_inst:screaming_particles=scream_part.instantiate()
	self.add_child(scream_part_inst)

func add_power_impulse(force:float,thickness:float,speed:float)->void:
	var pow_imp:=load("res://Componenents/Circular distorsion node/Circular distorsion.tscn")
	var power_imp_inst:circular_distorsion=pow_imp.instantiate()
	power_imp_inst.force=force
	power_imp_inst.thickness=thickness
	power_imp_inst.speed_given=speed
	power_imp_inst.given_center=get_viewport().get_visible_rect().size/2
	self.add_child(power_imp_inst)

func cam_adjustement_for_attack_and_lockings(camera_offset_no_offense_here:float)->void:
	if player.current_target:
		camera_offset_no_offense_here=player.global_position.distance_to(player.current_target.global_position)
		camera_offset_no_offense_here=clamp(camera_offset_no_offense_here,0.0,2.0)
	if player.is_locking:
		player.camera_force_rotation(camera_offset_no_offense_here)
		var look_pos = Vector3(player.current_target.aiming_node.global_position.x,
		player.global_position.y,
		player.current_target.global_position.z)
		self.look_at(look_pos,Vector3.UP)
		player.camera_and_mesh_rotation()

func _on_being_hit() -> void:
	pass
