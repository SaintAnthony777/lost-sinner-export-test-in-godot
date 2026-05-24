extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

const ATTACK_RANGE:=3.0
func enter() -> void:
	idle_animation()
	
func physics_update(_delta) -> void:
	status_check()

func status_check()->void:
	if halfrey_root.target.character.is_alive:
		if ((halfrey_root.global_position.distance_to(halfrey_root.target.global_position)) > ATTACK_RANGE and
		(halfrey_root.global_position.distance_to(halfrey_root.target.global_position) < 10)
	 	):
			state_machine.change_state("Slow Chase")
		elif halfrey_root.global_position.distance_to(halfrey_root.target.global_position)>=15:
			state_machine.change_state("Chasing fierce")
		else:
			state_machine.change_state("Attack state")
	if !halfrey_root.is_alive:
		state_machine.change_state("Dying")
	else:pass
	
func idle_animation()->void:
	halfrey.Boss_motion("Still","Idle")
