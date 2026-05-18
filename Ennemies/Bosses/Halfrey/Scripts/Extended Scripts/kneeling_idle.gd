extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

func enter() -> void:
	kneeling_idle_tricks()
	
func kneeling_idle_tricks()->void:
	halfrey.Boss_motion("Still","Getting Ready")
