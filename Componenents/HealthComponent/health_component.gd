class_name HealthComponent extends Node

var Current_health:float
var Damage_Factor:float

@export var Max_health:float
@export var Vulnerability:Array[String]
@export var Resistance:Array[String]
@export var Immunity:Array[String]
@export var Health_gauge:TextureProgressBar

func taking_damage(taken_attack:Attack):
	if taken_attack.Nature in Vulnerability:
		Damage_Factor=taken_attack.Base_damage*25/100
	elif taken_attack.Nature in Resistance:
		Damage_Factor=-taken_attack.Base_damage*5/100
	elif taken_attack.Nature in Immunity :
		Damage_Factor=-taken_attack.Base_damage
	Current_health-=taken_attack.Base_damage+Damage_Factor
	if Current_health<0:Current_health=0
