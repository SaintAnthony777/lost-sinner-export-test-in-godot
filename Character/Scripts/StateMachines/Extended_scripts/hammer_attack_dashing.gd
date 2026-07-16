extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var curr_weapon:Weapon=Weapon.new()

func enter() -> void:
	character.show_equipped_weapon()
	character.requested_next_attack=false
	character.requested_dash=false
	if character.gift_component.is_consummed:
		character.get_weapon_by_gift(player.chosen_gift).show()
		curr_weapon=character.get_weapon_by_gift(player.chosen_gift)
	else : character.emptied_enchantement();curr_weapon = character.get_weapon_by_gift("Neutral")
	attack_stuff()
	
func physics_update(_delta) -> void:
	attack_check()
	state_logic(_delta)
	character.check_attack_lunge(3.5,_delta)

func attack_stuff()->void:
	var atk:=Attack.new()
	atk.create_attack(
		curr_weapon.base_damage+randf_range(0.1,2.0),
		curr_weapon.strength+randf_range(0.1,0.5),
		curr_weapon.damage_nature,
		curr_weapon.stun_time+randf_range(0.1,0.2),
		0.0
	)
	character.dealt_attack=atk
	character.attacking("Normal","Hammer","attack_dashing")
func attack_check()->void:
	if Input.is_action_just_pressed("sprinting"):
		character.attack_lunge_boolean=false
		character.isrolling=true
		state_machine.change_state("normal_rolling")
	if character.is_attacking==false:
		state_machine.change_state("idle")
	if Input.is_action_just_pressed("Attack_trigger")and !character.requested_next_attack:character.requested_next_attack=true
	if character.can_advance_to_next_atack_pattern :
		if character.requested_next_attack==true:
			character.can_advance_to_next_atack_pattern=false
			state_machine.change_state("Hammer_attack_3")
func state_logic(delta)->void:
	player.camera_rotation_logic(delta)
