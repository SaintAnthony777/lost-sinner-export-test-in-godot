extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var curr_weapon:Weapon=Weapon.new()

func enter() -> void:
	character.attack_direction="left"
	character.requested_next_attack=false
	character.requested_dash=false
	if character.gift_component.is_consummed:
		character.get_weapon_by_gift(player.chosen_gift).show()
		curr_weapon=character.get_weapon_by_gift(player.chosen_gift)
	else : character.emptied_enchantement();curr_weapon = character.get_weapon_by_gift("Neutral")
	character.show_equipped_weapon()
	attack_stuff()
	
func physics_update(_delta) -> void:
	attack_check()
	state_logic(_delta)
	character.cam_adjustement_for_attack_and_lockings(.1)
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
	character.attacking("Normal","Hammer","attack_1")

func attack_check()->void:
	if character.requested_dash:
		character.isrolling=true
		if !player.is_locking:
			state_machine.change_state("normal_rolling")
		else:
			state_machine.change_state("locking_rolls")
	if character.can_advance_to_next_atack_pattern :
		if character.requested_next_attack==true:
			character.can_advance_to_next_atack_pattern=false
			state_machine.change_state("Hammer_attack_2")
	if character.is_attacking==false:
		if player.is_locking:
			state_machine.change_state("locking")
		else :
			state_machine.change_state("idle")

func state_logic(delta)->void:
	if Input.is_action_just_pressed("sprinting"):character.requested_dash=true
	if Input.is_action_just_pressed("Attack_trigger") and !character.requested_next_attack:character.requested_next_attack = true
	player.camera_rotation_logic(delta)
	character.check_attack_lunge(1.0,delta)
	
	if !player.is_locking : character.adjust_character_rotation(delta)
	else : character.force_lock_rotation()
		
	if character.is_taking_damage:
		character.is_attacking=false
		character.requested_next_attack=false
		character.requested_dash=false
		state_machine.change_state("taking_damage")
