class_name MainscreenUI extends Control

@onready var buttons_container: VBoxContainer = $"MarginContainer/Main buttons/Buttons container"
@onready var save_slots_row: VBoxContainer = $"MarginContainer/Save slots and descriptions/Save scrolls/Save Slots Row"

@onready var empty_data:PackedScene=preload("res://Componenents/Empty Data/empty_data.tscn")
@onready var existing_data:PackedScene=preload("res://Componenents/Existing Data/existing_data.tscn")

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
