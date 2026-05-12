class_name Attack extends Node

var Base_damage:float
var Strength:float
var Nature:String
var Stun_time:float
var arcane_consumption:float

func create_attack(dmg:float,stre:float,ntr:String,stn_tm:float,arc:float)->void:
	Base_damage=dmg
	Strength=stre
	Nature=ntr
	Stun_time=stn_tm
	arcane_consumption=arc
