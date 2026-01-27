extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	state_logics(_delta)
	if Input.is_action_just_released("Aiming") : state_machine.change_state("normal")
	if Input.is_action_just_pressed("locking") and player.current_target!=null : state_machine.change_state("locking")

func state_logics(delta:float):
	pass
