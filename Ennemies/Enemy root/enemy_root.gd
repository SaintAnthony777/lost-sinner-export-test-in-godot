extends CharacterBody3D
class_name enemy_root

var visuals:EnemyVisuals
var target:player_character
var dealt_attack:Attack
var aiming_node
@export var attack_range:float

func initialize_player() -> void:
	target=get_tree().get_first_node_in_group("Personnage")
	
func initialize_aiming_node()->void:
	aiming_node=get_node("aiming node")

func aiming_at_player()->void:
	self.look_at(Vector3(
		target.global_position.x,
		self.global_position.y,
		target.global_position.z
		)
	)
	self.rotate_y(PI)
