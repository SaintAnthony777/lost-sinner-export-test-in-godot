extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var charge_dir:=Vector3.ZERO

func enter() -> void:
	air_heavy_unleash_logic()

func physics_update(_delta) -> void:
	velocity_check(_delta)
	state_logic(_delta)
func state_logic(delta):
	if Input.is_action_just_pressed("Grace") or character.heavy_charge_ray_cast.is_colliding():
		state_machine.change_state("heavy charge stop")

func velocity_check(delta)->void:
	player.velocity=charge_dir*2500*delta
	player.move_and_slide()
	
func air_heavy_unleash_logic()->void:
	charge_dir=character.transform.basis.z.normalized()
	var target_angle = Vector3.BACK.signed_angle_to(charge_dir, Vector3.UP)
	character.global_rotation.y = target_angle
	character.jump_logics("Grace","Air Heavy Charge Unleash")
