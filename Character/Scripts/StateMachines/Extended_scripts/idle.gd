extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	character.is_blocking=false
	character.crosshair_layer.hide()
	player.is_busy=false
func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,75.0,.1)
	state_logic(_delta)
	input_logic()
	if !character.is_alive:state_machine.change_state("Dying")
	
func state_logic(delta)->void:
	if character.pick_back_hammer :
		state_machine.change_state("hammer_take_back")
	if !player.current_target and !character.gift_component.is_consummed:
		if character.can_throw_hammer:
			character.hide_equipped_weapon()
		else : character.unused_weapon_attachment.hide()
		character.normal_motion("Idle_unarmed")
	else:
		character.show_equipped_weapon()
		character.normal_motion("Idle_warned")
		if character.gift_component.is_consummed:
			if !character.can_throw_hammer:
				character.hide_equipped_weapon()
			else :
				character.get_weapon_by_gift(player.chosen_gift).show()
		else : character.emptied_enchantement()
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	if !player.is_on_floor():
		player.move_and_slide()
		character.landed=false
		state_machine.change_state("falling")
	taking_hit_check()
	
func taking_hit_check()->void:
	if character.is_taking_damage:
		state_machine.change_state("taking_damage")
		
func input_logic()->void:
	if player.player_direction!=Vector3.ZERO:
		state_machine.change_state("run")
		
	if Input.is_action_just_pressed("sprinting"):
		character.is_backfliping=true
		state_machine.change_state("backflip")
		
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("aiming")
		
	if Input.is_action_just_pressed("locking") and player.current_target:
		state_machine.change_state("locking")
		
	if Input.is_action_pressed("Blocks"):
		state_machine.change_state("shield_idle")
		
	if Input.is_action_just_pressed("Attack_trigger") and character.can_throw_hammer:
		character.is_attacking=true
		if character.gift_component.is_consummed:
			character.get_weapon_by_gift(player.chosen_gift).show()
		else : character.emptied_enchantement()
		character.show_equipped_weapon()
		state_machine.change_state("hammer_attack_1")
	
	if (Input.is_action_just_pressed("Special") and player.divine_divider_list and
	 character.arc_component.current_arcane>=player.divine_dividers_consumption_dict[player.current_divine_divider]):
		character.is_divine_dividing=true
		state_machine.change_state(player.current_divine_divider)
		
	if (Input.is_action_just_pressed("Grace") and player.grace_list and 
		character.arc_component.current_arcane>=player.grace_consumption_dict[player.current_grace]):
		character.is_making_grace=true
		state_machine.change_state(player.current_grace)
		
	if Input.is_action_just_pressed("Jump trigger"):
		character.landed=false
		state_machine.change_state("Jumping")
		
	if Input.is_action_just_pressed("Action trigger") and player.can_interact:
		character.interacts=true
		state_machine.change_state(player.interaction_type)
	
	if Input.is_action_just_pressed("Enchants") and character.gift_component.can_be_consumed:
		state_machine.change_state("Enchanting")
	if Input.is_action_just_pressed("Object_use") and player.current_item.item_number>0:
		player.used_item = player.current_item
		state_machine.change_state("Use object")
func exit() -> void:
	player.is_busy=true
