extends CharacterBody3D
class_name enemy_root

var visuals:EnemyVisuals
var target:player_character
var dealt_attack:Attack

@export var attack_range:float

func initialize_player() -> void:
	target=get_parent().get_node("Personnage")
func aiming_at_player()->void:
	visuals.look_at(Vector3(
		target.global_position.x,
		self.global_position.y,
		target.global_position.z
		)
	)
	visuals.rotate_y(PI)
