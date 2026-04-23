extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.velocity=Vector3.ZERO
	to_idle_logic()

func physics_update(_delta) -> void:
	state_logic(_delta)
	
func state_logic(delta)->void:
	player.gravity_applying(delta)
	player.move_and_slide()
	if !character.is_making_grace:
		state_machine.change_state("idle")
		
func to_idle_logic():
	character.special_attacks("Graces","Heavy Charge Stop")
