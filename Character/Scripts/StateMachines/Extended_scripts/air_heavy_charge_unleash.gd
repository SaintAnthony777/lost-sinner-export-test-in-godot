extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var charge_dir:=Vector3.ZERO
var Heavy_Strike:Attack=Attack.new()
func enter() -> void:
	Heavy_Strike.create_attack(
		35.0,
		200,
		"Grace",
		5.0,
		.5
	)
	character.dealt_attack=Heavy_Strike
	air_heavy_unleash_logic()
	character.thrust_forward_mesh.show()
	
func physics_update(_delta) -> void:
	velocity_check(_delta)
	state_logic(_delta)
	
func state_logic(_delta):
	character.arc_component.arcane_consumption(Heavy_Strike)
	if( Input.is_action_just_pressed("Grace") or character.heavy_charge_ray_cast.is_colliding() or 
	character.arc_component.current_arcane < Heavy_Strike.arcane_consumption):
		state_machine.change_state("heavy charge stop")
	player.camera_shaking(.2,3.0)
	
func velocity_check(delta)->void:
	
	player.velocity=charge_dir*2500*delta
	player.move_and_slide()
	player.push_rigids()
	
func air_heavy_unleash_logic()->void:
	charge_dir=character.transform.basis.z.normalized()
	var target_angle = Vector3.BACK.signed_angle_to(charge_dir, Vector3.UP)
	character.global_rotation.y = target_angle
	character.jump_logics("Grace","Air Heavy Charge Unleash")
func exit() -> void:
	character.thrust_forward_mesh.hide()
