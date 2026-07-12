extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var camera_offset_no_offense_here:float=1.0

func enter() -> void:
	player.camera_shaking(.1,1.0)
	taking_damage_tricks()
	
	state_check()
	
	
func physics_update(_delta) -> void:
	if !character.is_alive:player.is_locking=false;state_machine.change_state("Dying")
	character.cam_adjustement_for_attack_and_lockings(camera_offset_no_offense_here)
	player.gravity_applying(_delta)
	
	
func taking_damage_tricks()->void:
	character.taking_damage("Light")
	
func state_check()->void:
	if character.animation_tree:
		await character.animation_tree.animation_finished 
	character.is_taking_damage=false
	if !character.is_taking_damage:
		if !player.is_locking:
			state_machine.change_state("idle")
		else:
			print("quitted taking damage")
			state_machine.change_state("locking")
