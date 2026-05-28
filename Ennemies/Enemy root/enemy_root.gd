extends CharacterBody3D
class_name enemy_root

var visuals:EnemyVisuals
var target:player_character
var dealt_attack:Attack
var aiming_node:Marker3D
var is_alive:bool=true
var is_blocking:=false
@export var attack_range:float

func initialize_player() -> void:
	target=get_tree().get_first_node_in_group("Personnage")
	
func initialize_aiming_node()->void:
	aiming_node=get_node("aiming node")
func check_if_aimed_at():
	if target.current_target and target.current_target==self and target.is_locking:
		aiming_node.show()
	else:aiming_node.hide()
func _process(_delta: float) -> void: check_if_aimed_at()
func aiming_at_player()->void:
	self.look_at(Vector3(
		target.global_position.x,
		self.global_position.y,
		target.global_position.z
		)
	)
	self.rotate_y(PI)
