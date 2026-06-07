extends Node

const SAVE_PATH:="user://save_game_soaring_silence_1.res"
var current_save:GameSaveData=GameSaveData.new()

func save_game(player_node:player_character)->void:
	current_save.current_health=player_node.character.health_component.Current_health
	current_save.player_position=player_node.global_position
	current_save.current_scene = get_tree().current_scene.scene_file_path
	var error = ResourceSaver.save(current_save,SAVE_PATH)
	if error == OK:
		print("sauvegarde effectuée")
	else : 
		print("sauvegarde echouée")

func load_game() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		print('sauvegarde introuvable')
		return
	current_save = ResourceLoader.load(SAVE_PATH) as GameSaveData
	
	if current_save : 
		get_tree().change_scene_to_file(current_save.current_scene)
		await get_tree().node_added
		var player : player_character =get_tree().current_scene.find_child("Personnage")
		if player : 
			player.global_position = current_save.player_position
			player.character.health_component.Current_health=current_save.current_health
		
