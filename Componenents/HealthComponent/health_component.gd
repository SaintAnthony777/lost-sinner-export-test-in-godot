class_name HealthComponent extends Node

var Current_health:float
var Damage_Factor:float

var Moveable_Player:player_character
var Moveable_Body:enemy_root
var received_attack:Attack
var attack_sender
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

func _ready() -> void:
	Health_gauge.max_value=Max_health
	Current_health=Max_health
	
func _process(_delta: float) -> void:
	if Health_gauge:
		Health_gauge.value=lerp(Health_gauge.value,Current_health,.5)
	if received_attack:
		take_a_step(received_attack,_delta)

func taking_damage(taken_attack:Attack):
	if Moveable_Player:Moveable_Player.character.is_taking_damage=true
	if Moveable_Body:Moveable_Body.visuals.is_taking_damage=true
	if taken_attack.Nature in Vulnerability:
		Damage_Factor=taken_attack.Base_damage*25/100
	elif taken_attack.Nature in Resistance:
		Damage_Factor=-taken_attack.Base_damage*5/100
	elif taken_attack.Nature in Immunity :
		Damage_Factor=-taken_attack.Base_damage
		
	if Moveable_Player and Moveable_Player.character.is_blocking :
		var dealt_dmg=(taken_attack.Base_damage+Damage_Factor)-Armor_value
		if dealt_dmg<=0:dealt_dmg=0
		Current_health-=dealt_dmg
	else : Current_health-=taken_attack.Base_damage+Damage_Factor
	dealt_thrown_time=taken_attack.Stun_time
	if Current_health<0:Current_health=0
	if Current_health==0:
		if Node_to_call_on_death:
			Node_to_call_on_death.is_alive=false
		if player_to_call_on_death:
			player_to_call_on_death.is_alive=false
			
func take_a_step(taken_attack:Attack,delta:float):
	var expulsion_direction:Vector3=Vector3.ZERO
	if Bearable_power<=taken_attack.Strength:
		dealt_thrown_time-=(delta+1)
		var Node_to_be_rotated
		if Moveable_Body:
			Node_to_be_rotated=Moveable_Body.visuals
		if Moveable_Player:
			Node_to_be_rotated=Moveable_Player.character
		
		if dealt_thrown_time>0:
			if Moveable_Body:
				Node_to_be_rotated.owner.look_at(Vector3(
					attack_sender.global_position.x,
					Node_to_be_rotated.global_position.y,
					attack_sender.global_position.z
				))
				Node_to_be_rotated.owner.rotate_y(PI)
			else:
				Node_to_be_rotated.look_at(Vector3(
					attack_sender.global_position.x,
					Node_to_be_rotated.global_position.y,
					attack_sender.global_position.z
				))
				Node_to_be_rotated.rotate_y(PI)
			expulsion_direction=Node_to_be_rotated.transform.basis.z.normalized()
			Node_to_be_rotated.owner.velocity =-(expulsion_direction*taken_attack.Strength)
			Node_to_be_rotated.owner.move_and_slide()
		else:
			received_attack=null
