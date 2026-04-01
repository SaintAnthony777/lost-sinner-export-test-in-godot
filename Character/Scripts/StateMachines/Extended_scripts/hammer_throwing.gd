extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var instance 
var thrown_hammer_mesh:=load("res://Character/Miscs/Accessories/Weapons/Justicière des abysses/Scenes/thrown_hammer.tscn")

func enter() -> void:
	character.aiming_attack("Hammer_throwing")

func physics_update(_delta) -> void:
	state_logic()
	
func state_logic()->void:
	instance=thrown_hammer_mesh.instantiate()
	if character.thrown_hammer and is_instance_valid(instance):
		var target_point := player.get_target_point()
		get_parent().get_parent().get_parent().add_child(instance)
		instance.global_position=player.hammer_starting_point.global_position
		instance.transform.basis=player.hammer_starting_point.global_basis
		instance.look_at(target_point)
		character.equipped_hammer.hide()
		character.thrown_hammer=false
	if !character.is_attacking:
		state_machine.change_state("idle")
