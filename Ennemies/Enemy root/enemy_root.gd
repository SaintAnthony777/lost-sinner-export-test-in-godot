extends CharacterBody3D
class_name enemy_root

var visuals:Node3D
var target:player_character

func initialize_player() -> void:
	target=get_parent().get_node("Personnage")
