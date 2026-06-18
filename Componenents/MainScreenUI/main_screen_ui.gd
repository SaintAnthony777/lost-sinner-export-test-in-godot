class_name MainscreenUI extends Control

@onready var buttons_container: VBoxContainer = $"MarginContainer/Main buttons/Buttons container"
@onready var save_slots_row: VBoxContainer = $"MarginContainer/Save slots and descriptions/Save scrolls/Save Slots Row"

@onready var empty_data:=preload("res://Componenents/Empty Data/empty_data.tscn")
@onready var existing_data:=preload("res://Componenents/Existing Data/existing_data.tscn")
var data
func _ready() -> void: 
	for i in range(1,5):
		if ResourceLoader.exists("res://save_game_soaring_silence_"+str(i)+".res"):
			data=existing_data.instantiate()
			
		else : 
			data=empty_data.instantiate()
		save_slots_row.add_child(data)
