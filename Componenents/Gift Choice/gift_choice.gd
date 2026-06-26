class_name GiftChoice extends Control

@onready var personnage:player_character=get_tree().get_first_node_in_group("personnage")
@onready var Screaming_Silence : Inventory_Item = Inventory_Item.new()
@onready var Heavy_Charge : Inventory_Item = Inventory_Item.new()
@onready var Fire_of_Giants : Inventory_Item = Inventory_Item.new()
@onready var Lightning_Bolt : Inventory_Item = Inventory_Item.new()
@onready var new_save : GameSaveData = GameSaveData.new()

func create_items()->void:
	Screaming_Silence.create_item(
		"Screaming Silence",
		1,
		"This power describes very well the power that the giants had back then, a scream that anihilates almost anything near. A sinner once had enough power to recreate this shout but was condemned into the Lowlands Great Prison by the father of Darkness. He now awaits his time to escape from there ",
		false,
		"divine divider"
	)
	Heavy_Charge.create_item(
		"Heavy Charge",
		1,
		"Once the man they called the messenger of light had the power to travel at a marvelous speed between the worlds. No one was a match for his speed but when the world fell apart he could not run as fast anymore and was sunken by the scourge that had swallow the world. He gave the gift he received from the gods to a sinner no one knows where is at now but this power still represents the fierce strength of this speedster",
		false,
		"grace"
	)
	Lightning_Bolt.create_item(
		"Fury of the Gods",
		1,
		"A power that challenges nature itself, charge a weapon with a shard of lightning. When The mother of all humans forged her weapon of choice, the Hand of the Maestria, she gave it no magic power whatsoever but gave it the ability to adapt to almost any kind of existing enchantement. This gift from the gods is the ultimate form of expression that she made this weapon a great one.",
		false,
		"gift"
	)
	Fire_of_Giants.create_item(
		"Fire of the Giants",
		1,
		"A gift from Jack and the giants to Maerlyn, charge a weapon with a unstoppable fire .In collaboration with the giants, Jack created a gift that can infuse a power equal to the soul of a giant into a weapon, he then had the choice to infuse that power only in his shield but he did not, instead he gave this knowledge to Maerlyn and allowing her to make this creation even more perfect now that it can be infused in Maerlyn's Hammer.",
		false,
		"gift"
		)
func _ready() -> void:
	create_items()
	
func create_save_with_gift(ability:Inventory_Item,gift_here:Inventory_Item)->void:
	new_save.max_health=100
	new_save.max_arcane=100
	new_save.player_inventory=Inventory.new()
	new_save.player_inventory.add_item(ability,1)
	new_save.player_inventory.add_item(gift_here,1)
	new_save.player_gift = gift_here.item_name
	new_save.current_save_place="Prison cell"
	new_save.player_position=Vector3.ZERO
	new_save.current_scene="res://Greyboxed Environnements/The Great Prison/the_great_prison.tscn"
	var err = ResourceSaver.save(new_save,SaveManager.SAVE_PATH)
	if err==OK:
		print('sauvegarde créée')
		var save:GameSaveData=ResourceLoader.load(SaveManager.SAVE_PATH)
		if save :
			SaveManager.load_game()
	else:pass
func new_game_with_gifts(ability:Inventory_Item,gift:Inventory_Item) -> void :
	create_save_with_gift(ability,gift)
func _on_divine_divider_button_pressed() -> void:
	new_game_with_gifts(Screaming_Silence,Fire_of_Giants)
func _on_grace_button_pressed() -> void:
	new_game_with_gifts(Heavy_Charge,Lightning_Bolt)
