extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	character.use_regen_Item(player.used_item.item_name)
	
func physics_update(_delta) -> void:
	healing_factor_check()
	heal_to_idle_check()
	
func healing_factor_check()->void:
	if character.is_healing:
		character.is_healing=false
		player.player_inventory.substract_item(player.used_item,1)
		character.healing_factor(player.used_item)

func heal_to_idle_check()->void:
	await character.animation_tree.animation_finished 
	state_machine.change_state("idle")
