class_name GiftChoice extends Control

@onready var personnage:player_character=get_tree().get_first_node_in_group("personnage")
@onready var Screaming_Silence : Inventory_Item = Inventory_Item.new()
@onready var Heavy_Charge : Inventory_Item = Inventory_Item.new()
@onready var Fire_of_Giants : Inventory_Item = Inventory_Item.new()
@onready var Lightning_Bolt : Inventory_Item = Inventory_Item.new()
@onready var Evergreen_seeds : RegenItem = RegenItem.new()
@onready var Evergreen_fruits : RegenItem = RegenItem.new()
@onready var new_save : GameSaveData = GameSaveData.new()
@onready var hammer:Inventory_Item=Inventory_Item.new()
@onready var shield:Inventory_Item=Inventory_Item.new()

func create_items()->void:
	hammer.create_item(
		"The Hand of the Maestria",
		0,
		"The weapon wield by Maerlyn, the mother of all humans, said to be unbreakable, needs a godly amount of strength to be used at its peak. This hammer was said to choose a sinner as its new wielder once Maerlyn falls. The Story goes that this Hammer has no real magic despite its durability the only one who can say if it's true is no longer able to tell anything about it",
		true,
		"weapon"
	)
	shield.create_item(
		"Jack's Aegis",
		0,
		"This shield once belonged to the one they call the world's strongest man, it has the power to protect the one who uses it against everything that exists, a gift from Jack once he died, said to choose a sinner among the ones that remains. Jack made this shield by using his pure strength. in fact, it is said that Jack did never need to use a shield as he would bear with his body alone any hit that would land on him, the shield was meant to be a weapon to protect all of the humans, not him",
		true,
		"weapon"
	)
	Screaming_Silence.create_item(
		"Screaming Silence",
		0,
		"This power describes very well the power that the giants had back then, a scream that anihilates almost anything near. A sinner once had enough power to recreate this shout but was condemned into the Lowlands Great Prison by the father of Darkness. He now awaits his time to escape from there ",
		false,
		"divine divider"
	)
	Heavy_Charge.create_item(
		"Heavy Charge",
		0,
		"Once the man they called the messenger of light had the power to travel at a marvelous speed between the worlds. No one was a match for his speed but when the world fell apart he could not run as fast anymore and was sunken by the scourge that had swallow the world. He gave the gift he received from the gods to a sinner no one knows where is at now but this power still represents the fierce strength of this speedster",
		false,
		"grace"
	)
	Lightning_Bolt.create_item(
		"Fury of the Gods",
		0,
		"A power that challenges nature itself, charge a weapon with a shard of lightning. When The mother of all humans forged her weapon of choice, the Hand of the Maestria, she gave it no magic power whatsoever but gave it the ability to adapt to almost any kind of existing enchantement. This gift from the gods is the ultimate form of expression that she made this weapon a great one.",
		false,
		"gift"
	)
	Fire_of_Giants.create_item(
		"Fire of the Giants",
		0,
		"A gift from Jack and the giants to Maerlyn, charge a weapon with a unstoppable fire .In collaboration with the giants, Jack created a gift that can infuse a power equal to the soul of a giant into a weapon, he then had the choice to infuse that power only in his shield but he did not, instead he gave this knowledge to Maerlyn and allowing her to make this creation even more perfect now that it can be infused in Maerlyn's Hammer.",
		false,
		"gift"
		)
	Evergreen_seeds.create_item(
		"Evergreen Seeds",
		0,
		"A seed of the mystic tree called the Evergreen, allows to heal wounds, can be replenished by resting at an evergreen shard. No one never really knew from where did the evergreen ever came, but all agrees to say that it's pretty powerful as it can repel most of afflictions. When the world fell apart, the evergreen almost vanished from the world leaving only a few of its shards remaining here. Those shards are not very impressive but they can be used as restpoints for the few living sane creatures in these lands.",
		true,
		"object"
	)
	Evergreen_seeds.set_regen_type_and_value(
		"health",
		35.0,
		Evergreen_seeds.item_name,
		Color(0.0, 2.922, 1.101)
	)
	Evergreen_fruits.set_regen_type_and_value(
		"arcane",
		35.0,
		Evergreen_fruits.item_name,
		Color(0.0, 0.661, 3.383)
	)
	Evergreen_fruits.create_item(
		"Evergreen Fruit",
		0,
		"A fruit of the mystic tree called the Evergreen, allows to regen arcane, can be replenished by resting at an evergreen shard. This fruit is a quite rare and blessful gift from the evergreen itself . The fruits crystalize themselves once they are out in the air, condensing a high amount of magic in them. No matter how powerful divine dividers and graces are, in this world they still depend on this mysterious source called the evergreen, so be cautious when using those powers.",
		true,
		"object"
	)
func _ready() -> void:
	create_items()
	
func create_save_with_gift(ability:Inventory_Item,gift_here:Inventory_Item)->void:
	new_save.max_health=100
	new_save.max_arcane=100
	new_save.max_gift_gauge=100
	new_save.current_arcane=100
	new_save.current_gift_gauge=100
	new_save.current_health=100
	new_save.max_fruits = 5
	new_save.max_seeds = 7
	new_save.player_inventory=Inventory.new()
	new_save.player_inventory.add_item(ability,1)
	new_save.player_inventory.add_item(gift_here,1)
	new_save.player_inventory.add_item(Evergreen_fruits,new_save.max_fruits)
	new_save.player_inventory.add_item(Evergreen_seeds,new_save.max_seeds)
	new_save.player_inventory.add_item(hammer,1)
	new_save.player_inventory.add_item(shield,1)
	new_save.player_gift = gift_here.item_name
	new_save.current_save_place="Prison cell"
	new_save.player_position=Vector3.ZERO
	new_save.current_scene="res://Greyboxed Environnements/The Great Prison/the_great_prison.tscn"
	SaveManager.current_save=new_save
	
	var err = ResourceSaver.save(new_save,SaveManager.SAVE_PATH)
	if err==OK:
		print('sauvegarde créée')
		var save:GameSaveData=ResourceLoader.load(SaveManager.SAVE_PATH)
		if save :
			print(save.current_scene)
			get_tree().change_scene_to_file("res://Componenents/Loading Screen/loading_screen.tscn")
	else:pass
	
func new_game_with_gifts(ability:Inventory_Item,gift:Inventory_Item) -> void :
	create_save_with_gift(ability,gift)
func _on_divine_divider_button_pressed() -> void:
	new_game_with_gifts(Screaming_Silence,Fire_of_Giants)
func _on_grace_button_pressed() -> void:
	new_game_with_gifts(Heavy_Charge,Lightning_Bolt)
