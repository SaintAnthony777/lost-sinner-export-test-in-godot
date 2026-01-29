extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	state_logics()
func state_logics () -> void :
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("run")
	else : state_machine.change_state("idle") 
	if Input.is_action_pressed("Aiming"):state_machine.change_state("aiming")
	if Input.is_action_just_pressed("locking") and player.current_target!=null : state_machine.change_state("locking")
	
