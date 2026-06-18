class_name MainscreenUI extends Control

@onready var buttons_container: VBoxContainer = $"MarginContainer/Main buttons/Buttons container"
@onready var save_slots_row: VBoxContainer = $"MarginContainer/Save slots and descriptions/Save scrolls/Save Slots Row"

@onready var empty_data:=preload("res://Componenents/Empty Data/empty_data.tscn")
@onready var existing_data:=preload("res://Componenents/Existing Data/existing_data.tscn")
const SAVE_GAME_SOARING_SILENCE_1 = preload("res://save_data/save_game_soaring_silence_1.tres")

func _ready() -> void: 
	for i in range(1,5):
		if ResourceLoader.exists("res://save_data/save_game_soaring_silence_"+str(i)+".tres"):
			var data : ExistingData = existing_data.instantiate()
			data.current_save=ResourceLoader.load("res://save_data/save_game_soaring_silence_"+str(i)+".tres")
			data.save_Id=i
			print("res://save_game_soaring_silence_"+str(i)+".res")
			save_slots_row.add_child(data)
		else : 
			var data:EmptyData=empty_data.instantiate()
			data.save_id=i
			save_slots_row.add_child(data)
