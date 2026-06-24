extends Node

var SAVE_PATH:=""
var current_save:GameSaveData=GameSaveData.new()
const FOLDER_PATH:String="user://save_data"
func save_game(player_node:player_character)->void:
	
	player_node.character.health_component.Current_health=player_node.character.health_component.Max_health
	current_save.current_health = player_node.character.health_component.Current_health
	player_node.character.arcane_component.current_arcane=player_node.character.arcane_component.Max_Arcane
	current_save.player_position = player_node.global_position
	current_save.player_rotation_degrees = player_node.rotation_degrees
	current_save.current_scene = get_tree().current_scene.scene_file_path
	current_save.current_save_place = player_node.current_level_played.get_closest_save_point().save_place_name
	current_save.player_inventory = player_node.player_inventory
	current_save.player_gift = player_node.chosen_gift
	if not DirAccess.dir_exists_absolute(FOLDER_PATH):
		DirAccess.make_dir_absolute(FOLDER_PATH)
	var error = ResourceSaver.save(current_save,SAVE_PATH)
	if error == OK:
		print("sauvegarde effectuée")
	else : 
		print(error)
		print("sauvegarde echouée")

func load_game() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		print('sauvegarde introuvable')
	current_save = ResourceLoader.load(SAVE_PATH)
	if current_save : 
		get_tree().change_scene_to_file(current_save.current_scene)
		await get_tree().node_added
		var player : player_character = get_tree().current_scene.find_child("Personnage")
		if player : 
			player.global_position = current_save.player_position
			player.rotation_degrees = current_save.player_rotation_degrees
			player.player_inventory = current_save.player_inventory
			player.chosen_gift = current_save.player_gift
			player.save_location = current_save.current_save_place
			if current_save.player_inventory:
				for element:Inventory_Item in current_save.player_inventory.Inventory_list:
					if element.category == "divine divider":
						player.divine_divider_list.append(element.item_name)
					if element.category == "grace":
						player.grace_list.append(element.item_name)
