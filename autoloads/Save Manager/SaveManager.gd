extends Node

var SAVE_PATH:=""
var current_save:GameSaveData=GameSaveData.new()
const FOLDER_PATH:String="user://save_data"
var new_scene
func save_game(player_node:player_character)->void:
	save_stats(player_node)
	current_save.player_position=player_node.global_position
	current_save.current_scene = get_tree().current_scene.scene_file_path
	current_save.current_save_place = player_node.current_level_played.get_closest_save_point().save_place_name
	write_save()

func write_save()->void:
	if not DirAccess.dir_exists_absolute(FOLDER_PATH):
		DirAccess.make_dir_absolute(FOLDER_PATH)
	var error = ResourceSaver.save(current_save,SAVE_PATH)
	if error == OK:
		print("sauvegarde effectuée")
	else : 
		print(error)
		print("sauvegarde echouée")
		
		
func restor_health_and_arcane(player_node:player_character)->void:
	player_node.character.health_component.Current_health = player_node.character.health_component.Max_health
	player_node.character.arc_component.current_arcane = player_node.character.arc_component.Max_Arcane
	player_node.character.gift_component.current_gift_lvl = player_node.character.gift_component.max_gift
	
func restore_seeds_and_fruits(player:player_character)->void:
	for element in player.player_inventory.Inventory_list :
		if element and element is RegenItem:
			if element.item_name=="Evergreen Seeds":
				element.item_number=player.max_seeds
			if element.item_name=="Evergreen Fruit":
				element.item_number=player.max_fruits
	
func load_game() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		print('sauvegarde introuvable')
	current_save = ResourceLoader.load(SAVE_PATH)
	if current_save : 
		get_tree().change_scene_to_packed(new_scene)
		await  get_tree().process_frame
		await get_tree().node_added
		
		var player : player_character = null
		while player == null:
			await get_tree().process_frame
			player = get_tree().current_scene.find_child("Personnage",true,false)
		await get_tree().process_frame
		
		if player : 
			player.global_position = current_save.player_position
			player.rotation_degrees = current_save.player_rotation_degrees
			player.player_inventory = current_save.player_inventory
			player.chosen_gift = current_save.player_gift
			player.max_fruits = current_save.max_fruits
			player.max_seeds = current_save.max_seeds
			player.save_location = current_save.current_save_place
			
			player.character.health_component.Current_health=current_save.current_health
			player.character.arc_component.current_arcane=current_save.current_arcane
			player.character.gift_component.current_gift_lvl=current_save.current_gift_gauge
			
			player.character.health_component.Max_health = current_save.max_health
			player.character.arc_component.Max_Arcane = current_save.max_arcane
			player.character.gift_component.max_gift = current_save.max_gift_gauge
			
			if current_save.player_inventory:
				for element:Inventory_Item in current_save.player_inventory.Inventory_list:
					if element.category == "divine divider":
						print(element.category)
						player.divine_divider_list.append(element.item_name)
					if element.category == "grace":
						player.grace_list.append(element.item_name)

func specific_save(player_node:player_character,given_postion:Vector3,given_path:String)->void:
	save_stats(player_node)
	current_save.player_position=given_postion
	current_save.current_scene=given_path
	write_save()
	
func save_stats(player_node:player_character):
	current_save.current_health = player_node.character.health_component.Current_health
	current_save.current_arcane = player_node.character.arc_component.current_arcane
	current_save.current_gift_gauge = player_node.character.gift_component.current_gift_lvl
	
	
	current_save.max_health = player_node.character.health_component.Max_health
	current_save.max_arcane = player_node.character.arc_component.Max_Arcane
	current_save.max_gift_gauge = player_node.character.gift_component.max_gift
	
	current_save.player_inventory = player_node.player_inventory
	current_save.player_gift = player_node.chosen_gift
	current_save.max_fruits = player_node.max_fruits
	current_save.max_seeds = player_node.max_seeds
	
