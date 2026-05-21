extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

func enter() -> void:
	getting_ready_tricks()
	
func getting_ready_tricks()->void:
	halfrey.Boss_motion("Still","Getting Ready")
func physics_update(_delta) -> void:
	if halfrey.is_ready:
		state_machine.change_state("idle")
