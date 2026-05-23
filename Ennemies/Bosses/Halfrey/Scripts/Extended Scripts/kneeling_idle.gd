extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

func enter() -> void:
	kneeling_idle_tricks()
	
func kneeling_idle_tricks()->void:
	halfrey.Boss_motion("Still","Kneeling Idle")
	
func physics_update(_delta) -> void:
	check_Idle_Stop()
	
func check_Idle_Stop()->void:
	if halfrey_root.global_position.distance_to(halfrey_root.target.global_position)<=15.0:
		pass
		state_machine.change_state("Getting Ready")
