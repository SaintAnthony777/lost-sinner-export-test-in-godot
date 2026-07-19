class_name HealthComponent extends Node

@onready var Current_health:float
@onready var is_invulnerable:bool=false
@onready var playernode:player_character=get_tree().get_first_node_in_group("Personnage")
var Damage_Factor:float=0.0

var Moveable_Player:player_character
var Moveable_Body:enemy_root
var received_attack:Attack
var attack_sender : Node3D
var dealt_thrown_time:float=.0

@export var Max_health:float
@export var Vulnerability:Array[String]
@export var Resistance:Array[String]
@export var Immunity:Array[String]
@export var Health_gauge:TextureProgressBar
@export var Bearable_power:float
@export var Armor_value:float
@export var Node_to_call_on_death:enemy_root
@export var player_to_call_on_death:character_mesh
@export var random_node_to_call_on_death:fracturable_static
@export var body_nature:String


func _ready() -> void:
	Current_health=Max_health
	if Health_gauge:
		Health_gauge.max_value=Max_health
func _process(_delta: float) -> void:
	if Health_gauge:
		Health_gauge.value=lerp(Health_gauge.value,Current_health,.5)
	if received_attack:
		take_a_step(received_attack,_delta)
	if Current_health>Max_health:Current_health=Max_health
	
func Iframes_on()->void:
	is_invulnerable=true
func Iframes_off()->void:
	is_invulnerable=false
	
func regen_health(health_regen:float)->void:
	Current_health+=health_regen
	if Current_health>=Max_health:Current_health=Max_health

func taking_damage(taken_attack:Attack):
	# check invulnerability
	if is_invulnerable : HitStopManager.hit_stop_function(.01,.1) ; return
	
	#check block status
	if owner is character_mesh or owner is EnemyVisuals:
		owner.is_taking_damage=true
	
	if (owner is character_mesh or owner is EnemyVisuals) and owner.is_blocking :
		self.body_nature="metal"
		play_sfx()
		var dealt_dmg=(taken_attack.Base_damage+Damage_Factor)-Armor_value
		if dealt_dmg < 0 : dealt_dmg=0
		Current_health-=dealt_dmg
		dealt_thrown_time=taken_attack.Stun_time
		death_check()
		return
		
	#damage calculation
	if taken_attack.Nature in Vulnerability:
		Damage_Factor=taken_attack.Base_damage*25/100
	elif taken_attack.Nature in Resistance:
		Damage_Factor=-taken_attack.Base_damage*5/100
	elif taken_attack.Nature in Immunity :
		Damage_Factor=-taken_attack.Base_damage
	else : Damage_Factor = 0;Current_health-=(taken_attack.Base_damage+Damage_Factor)
	dealt_thrown_time=taken_attack.Stun_time
	Current_health-=(taken_attack.Base_damage+Damage_Factor)
	
	#play sounds
	play_sfx()
	
	#death ckeck
	death_check()
	if Current_health==0:
		HitStopManager.hit_stop_function(.3,.8)
		owner.is_alive=false
	else :
		HitStopManager.hit_stop_function(.01,.2)
	
func death_check()->void:
	if Current_health<0:Current_health=0
	
func take_a_step(taken_attack:Attack,delta:float):
	if is_invulnerable : return
	if !owner.is_alive : return
	if !attack_sender : return
	var expulsion_dir:Vector3=Vector3.ZERO
	if Bearable_power<=taken_attack.Strength:
		dealt_thrown_time-=(delta+1.5)
		if dealt_thrown_time>0:
			if owner is EnemyVisuals or owner is character_mesh and (attack_sender and owner) :
				owner.look_at(Vector3(
					attack_sender.global_position.x,
					owner.global_position.y,
					attack_sender.global_position.z,
				))
				owner.rotate_y(PI)
				expulsion_dir = -(Vector3(attack_sender.global_position - owner.global_position)).normalized()
				expulsion_dir.y = 0
				owner.get_parent().velocity = expulsion_dir*(taken_attack.Strength-Bearable_power)
		else:
			received_attack=null

func play_sfx()->void:
	if !body_nature:
		return
	var hitimpact:Hitsound_impact=Hitsound_impact.new()
	hitimpact.hitsound_type=body_nature
	self.add_child(hitimpact)
	hitimpact.load_sound()
