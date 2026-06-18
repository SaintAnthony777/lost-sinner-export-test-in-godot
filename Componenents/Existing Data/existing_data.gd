class_name ExistingData extends PanelContainer

@export var current_save : GameSaveData
@export var save_Id : int
@onready var snaps_for_save: TextureRect = $"Descripiton and screenshot2/Container/Snaps for save"
@onready var saveplace: Label = $"Descripiton and screenshot2/Container2/Saveplace"

func _ready() -> void:
	if current_save:
		saveplace.text=current_save.current_save_place
		snaps_for_save.texture=load("res://Componenents/Save Point/Snaps for save points/"+current_save.current_save_place+".png")


func _on_load_pressed() -> void:
	SaveManager.SAVE_PATH="res://save_data/save_game_soaring_silence_"+str(save_Id)+".tres"
	SaveManager.load_game()
