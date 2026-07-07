extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var charge_dir:=Vector3.ZERO
var Heavy_Strike:Attack=Attack.new()

func enter() -> void:
	character.thrust_forward_mesh.show()
	Heavy_Strike.create_attack(
		35.0,
		200,
		"Grace",
		5.0,
		.5
	)
	character.dealt_attack=Heavy_Strike
	unleash_trick()
	
func state_logic(_delta)->void:
	character.arc_component.arcane_consumption(Heavy_Strike)
	if( Input.is_action_just_pressed("Grace") or character.heavy_charge_ray_cast.is_colliding() or 
	character.arc_component.current_arcane < Heavy_Strike.arcane_consumption):
		state_machine.change_state("Heavy Charge Stop")
	player.camera_shaking(.2,3.0)
	
func physics_update(_delta) -> void:
	state_logic(_delta)
	velocity_check(_delta)
	player.camera_rotation_logic(_delta)
	
func velocity_check(delta)->void:
	player.velocity=charge_dir*50
	player.move_and_slide()
	player.push_rigids()
	
func unleash_trick()->void:
	charge_dir=character.transform.basis.z.normalized()
	var target_angle = Vector3.BACK.signed_angle_to(charge_dir, Vector3.UP)
	character.global_rotation.y = target_angle
	character.special_attacks("Graces","Heavy Charge Unleash")
func exit() -> void:
	character.thrust_forward_mesh.hide()
