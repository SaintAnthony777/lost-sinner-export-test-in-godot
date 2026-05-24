extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

func enter() -> void:
	halfrey.sword_hitbox_component.collsion_shape.disabled=true
	halfrey.AOE_hitbox.collsion_shape.disabled=true
	
	dying_state()
func dying_state()->void:
	halfrey.Boss_motion("Still","Died")
