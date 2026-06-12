extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var charge_dir:=Vector3.ZERO
var Heavy_Strike:Attack=Attack.new()
func enter() -> void:
	Heavy_Strike.create_attack(
		35.0,
		200,
		"grace",
		5.0,
		1.0
	)
	character.dealt_attack=Heavy_Strike
	unleash_trick()
	
func state_logic(_delta)->void:
	character.arcane_component.arcane_consumption(Heavy_Strike)
	if( Input.is_action_just_pressed("Grace") or character.heavy_charge_ray_cast.is_colliding() or 
	character.arcane_component.current_arcane <= 1.0):
		state_machine.change_state("Heavy Charge Stop")
func physics_update(_delta) -> void:
	state_logic(_delta)
	velocity_check(_delta)

func velocity_check(delta)->void:
	player.velocity=charge_dir*2500*delta
	player.move_and_slide()
	player.push_rigids()
func unleash_trick()->void:
	charge_dir=character.transform.basis.z.normalized()
	var target_angle = Vector3.BACK.signed_angle_to(charge_dir, Vector3.UP)
	character.global_rotation.y = target_angle
	character.special_attacks("Graces","Heavy Charge Unleash")
