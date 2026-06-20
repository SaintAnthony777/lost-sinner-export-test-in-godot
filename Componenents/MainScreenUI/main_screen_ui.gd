class_name MainscreenUI extends Control

@onready var buttons_container: VBoxContainer = $"MarginContainer/Main buttons/Buttons container"
@onready var save_slots_row: VBoxContainer = $"MarginContainer/Save slots and descriptions/Save scrolls/Save Slots Row"

@onready var empty_data:PackedScene=preload("res://Componenents/Empty Data/empty_data.tscn")
@onready var existing_data:PackedScene=preload("res://Componenents/Existing Data/existing_data.tscn")
@onready var copyrights_margin_container: MarginContainer = $"MarginContainer/Copyrights Margin Container"
@onready var main_buttons: VBoxContainer = $"MarginContainer/Main buttons"
@onready var save_slots_and_descriptions: VBoxContainer = $"MarginContainer/Save slots and descriptions"
@onready var options: MarginContainer = $MarginContainer/Options

func _ready() -> void:
	init_slots() 
func init_slots() -> void:
	for elements in save_slots_row.get_children():
		elements.queue_free()
	for i in range(1,5):
		if ResourceLoader.exists("user://save_data/save_game_soaring_silence_"+str(i)+".res"):
			var data : ExistingData = existing_data.instantiate()
			data.current_save=ResourceLoader.load("user://save_data/save_game_soaring_silence_"+str(i)+".res")
			data.save_Id=i
			save_slots_row.add_child(data)
		else : 
			var emptydata:EmptyData=empty_data.instantiate()
			emptydata.save_id=i
			save_slots_row.add_child(emptydata)


func _on_start_game_pressed() -> void:
	reverse_show()


func _on_back_pressed() -> void:
	reverse_show()

func reverse_show()->void:
	save_slots_and_descriptions.visible=!save_slots_and_descriptions.visible
	main_buttons.visible=!main_buttons.visible
	copyrights_margin_container.visible=!copyrights_margin_container.visible

func reverse_from_options()->void:
	options.visible=!options.visible
	main_buttons.visible=!main_buttons.visible
	copyrights_margin_container.visible=!copyrights_margin_container.visible

func _on_back_from_options_pressed() -> void:
	reverse_from_options()


func _on_options_pressed() -> void:
	reverse_from_options()
