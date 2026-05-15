extends CharacterBody3D
class_name enemy_root

var visuals:EnemyVisuals
var target:player_character
var dealt_attack:Attack

@export var attack_range:float

func initialize_player() -> void:
	target=get_parent().get_node("Personnage")
