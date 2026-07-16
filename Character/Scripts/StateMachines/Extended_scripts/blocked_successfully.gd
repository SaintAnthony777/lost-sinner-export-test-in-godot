extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
var camera_offset_no_offense_here:float

func enter() -> void:
	#player.camera_shaking(character.health_component.received_attack.Strength/10,.1)
	
	character.shield_motion("Blocking impact",Vector2.ZERO)
	await character.animation_tree.animation_finished
	character.is_taking_damage= false
	if !character.is_taking_damage:
		player.velocity=Vector3.ZERO
		if !player.is_locking:
			state_machine.change_state("shield_idle")
		else:
			state_machine.change_state("shield_locking")
			
func physics_update(_delta) -> void:
	character.cam_adjustement_for_attack_and_lockings(camera_offset_no_offense_here)
	player.gravity_applying(_delta)
	player.nullyfying_velocity(_delta)
	player.move_and_slide()
	
