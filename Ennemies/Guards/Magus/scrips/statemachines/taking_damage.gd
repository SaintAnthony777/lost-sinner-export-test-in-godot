extends State
@onready var magus_1: regular_enemy = $"../.."
@onready var refined_magus: EnemyVisuals = $"../../refined Magus"

func enter() -> void:
	status_check()

func _process(delta: float) -> void:
	magus_1.move_and_slide()
	magus_1.nullyfying_velocity(delta)
func status_check()->void:
	await refined_magus.animation_tree.animation_finished
	print("changes state")
	refined_magus.is_taking_damage=false
	if !refined_magus.is_alive:return
	if !refined_magus.is_taking_damage:
		magus_1.velocity=Vector3.ZERO
		if magus_1.is_target_in_range() : 
			print("attacks")
			state_machine.change_state("distant attack")
		else :
			print("chasing")
			state_machine.change_state("swift chase")
