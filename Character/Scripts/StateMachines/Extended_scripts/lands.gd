extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	land_logics()
	

func physics_update(_delta) -> void:
	state_logic(_delta)

func state_logic(delta)->void:
	input_check()
	player.camera_rotation_logic(delta)

func input_check()->void:
	if player.player_direction!=Vector3.ZERO:
		character.landed=true
		state_machine.change_state("run")
	if character.landed: state_machine.change_state("idle")

func land_logics()->void:
	character.jump_logics("Normal","Lands")
