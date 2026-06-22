class_name GiftChoice extends Control

@onready var personnage:player_character=get_tree().get_first_node_in_group("personnage")
@onready var Screaming_Silence : Inventory_Item = Inventory_Item.new()
@onready var Heavy_Charge : Inventory_Item = Inventory_Item.new()
@onready var new_save : GameSaveData = GameSaveData.new()
func create_items()->void:
	Screaming_Silence.create_item(
		"Screaming Silence",
		1,
		"This power describes very well the power that the giants had back then, a scream that anihilates almost anything near
		A sinner once had enough power to recreate this shout but was condemned into the Lowlands Great Prison by the father of Darkness.
		He now awaits his time to escape from there ",
		false,
		"divine divider"
	)
	Heavy_Charge.create_item(
		"Heavy Charge",
		1,
		"Once the man they called the messenger of light had the power to travel at a marvelous speed between the worlds.
		No one was a match for his speed but when the world fell apart he could not rn as fas anymore and was sunken by the scourge that had swallow the world.
		He gave the gift he received from the gods to a sinner no one knows where is at now but this power still represents the fierce strength of this speedster",
		false,
		"grace"
	)
func _ready() -> void:
	create_items()
func create_save_with_gift(gift_here:Inventory_Item)->void:
	new_save.max_health=100
	new_save.max_arcane=100
	new_save.player_inventory=Inventory.new()
	new_save.player_inventory.add_item(gift_here,1)
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
func new_game_with_gifts(gift:Inventory_Item) -> void :
	create_save_with_gift(gift)
func _on_divine_divider_button_pressed() -> void:
	new_game_with_gifts(Screaming_Silence)
func _on_grace_button_pressed() -> void:
	new_game_with_gifts(Heavy_Charge)
