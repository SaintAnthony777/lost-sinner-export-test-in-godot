extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.look_at(Vector3(player.looking_at_node.global_position.x,
	player.global_position.y,
	player.looking_at_node.global_position.z),Vector3.UP,true)
func physics_update(_delta) -> void:
	attack_stuff()
	attack_check()
	state_logic(_delta)
	character.check_attack_lunge(3.5)
func attack_stuff()->void:
	character.attacking("Normal","Hammer","attack_jumping")

func attack_check()->void:
	if character.is_attacking==false:
		state_machine.change_state("idle")

func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
