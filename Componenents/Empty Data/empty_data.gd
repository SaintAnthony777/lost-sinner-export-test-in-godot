class_name EmptyData extends PanelContainer

@export var save_id : int
@onready var label: Label = $"Save Slot 2/HBoxContainer/Label"
func _ready() -> void:
	label.text=str(save_id)+". "
func _on_menu_button_pressed() -> void:
	SaveManager.SAVE_PATH="user://save_data/save_game_soaring_silence_"+str(save_id)+".res"
	get_tree().change_scene_to_file("res://Greyboxed Environnements/The Great Prison/the_great_prison.tscn")
