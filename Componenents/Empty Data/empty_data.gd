class_name EmptyData extends PanelContainer

@export var save_id : int


func _on_menu_button_pressed() -> void:
	SaveManager.SAVE_PATH="res://save_data/save_game_soaring_silence_"+str(save_id)+".tres"
	get_tree().change_scene_to_file("res://Greyboxed Environnements/The Great Prison/the_great_prison.tscn")
