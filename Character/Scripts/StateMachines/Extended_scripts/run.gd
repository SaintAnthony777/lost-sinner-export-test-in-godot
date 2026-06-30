extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

@export var running_speed:=6.0
func enter() -> void:
	character.is_blocking=false
	character.crosshair_layer.hide()
	#character.health_component.Armor_value=15
	player.is_busy=false
func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,85.0,.1)
	state_logic(_delta)
	Player_Input_events()
	if !character.is_alive:state_machine.change_state("Dying")

func state_logic(delta)->void:
	if character.pick_back_hammer:state_machine.change_state("hammer_take_back")
	if !player.current_target and !character.gift_component.is_consummed:
		if character.can_throw_hammer:
			character.hide_equipped_weapon()
		else : character.unused_weapon_attachment.hide()
	else : 
		character.show_equipped_weapon()
		if character.gift_component.is_consummed:
			if !character.can_throw_hammer:
				character.hide_equipped_weapon()
			else :
				character.get_weapon_by_gift(player.chosen_gift).show()
		else : character.emptied_enchantement()
	player.SPEED=running_speed
	player.gravity_applying(delta)
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	character.normal_motion("Run")
	if !player.is_on_floor():
		character.landed=false
		state_machine.change_state("falling")
	if character.is_taking_damage:
		state_machine.change_state("taking_damage")


func Player_Input_events() -> void:
	if player.velocity==Vector3.ZERO and player.player_direction==Vector3.ZERO:
		state_machine.change_state("idle")

	if Input.is_action_pressed("sprinting"):
		state_machine.change_state("sprinting")
	
	if Input.is_action_just_pressed("sprinting") : 
		character.isrolling=true
		state_machine.change_state("normal_rolling")
	
	if Input.is_action_pressed("Aiming"):
		state_machine.change_state("aiming")
	
	if Input.is_action_just_pressed("locking") and player.current_target:
		state_machine.change_state("locking")

	if Input.is_action_pressed("Blocks"):
		state_machine.change_state("shield_normal")
		
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
