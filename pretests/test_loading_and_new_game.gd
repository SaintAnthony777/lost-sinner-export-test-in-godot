extends Control


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Greyboxed Environnements/The Great Prison/the_great_prison.tscn")
 	


func _on_load_game_pressed() -> void:
	SaveManager.load_game()
