class_name ExistingData extends PanelContainer

@export var current_save : GameSaveData
@export var save_Id : int
@onready var snaps_for_save: TextureRect = $"Descripiton and screenshot2/Snaps for save"
@onready var saveplace: Label = $"Descripiton and screenshot2/Container2/Saveplace"
@onready var confirm_delete_panel: PanelContainer = $"Confirm delete panel"
@onready var confirm: menu_button = $"Confirm delete panel/Confirm delete/HBoxContainer/Confirm"
@onready var revoke: menu_button = $"Confirm delete panel/Confirm delete/HBoxContainer/revoke"
@onready var delete: menu_button = $"Descripiton and screenshot2/Container2/Load or delete/Delete"
@onready var mainscreen:MainscreenUI = get_parent().owner
@export var empty_data:PackedScene=load("res://Componenents/Empty Data/empty_data.tscn")

func _ready() -> void:
	if current_save:
		saveplace.text=str(save_Id)+". "+current_save.current_save_place
		snaps_for_save.texture=load("res://Componenents/Save Point/Snaps for save points/"+current_save.current_save_place+".png")
func _on_load_pressed() -> void:
	SaveManager.SAVE_PATH="user://save_data/save_game_soaring_silence_"+str(save_Id)+".res"
	SaveManager.current_save=load(SaveManager.SAVE_PATH)
	get_tree().change_scene_to_file("res://Componenents/Loading Screen/loading_screen.tscn")
func _on_confirm_pressed() -> void: 
	if DirAccess.open("user://").file_exists("user://save_data/save_game_soaring_silence_"+str(save_Id)+".res"):
		var error = DirAccess.open("user://").remove("user://save_data/save_game_soaring_silence_"+str(save_Id)+".res")
		if error == OK:
			print("sauvegarde supprimmée")
			var new_data : EmptyData = empty_data.instantiate()
			new_data.save_id=save_Id
			mainscreen.save_slots_row.get_child(save_Id-1).add_sibling(new_data)
			mainscreen.save_slots_row.get_child(save_Id-1).queue_free()
		else: print("erreur lors de la suppression")
		

func _on_revoke_pressed() -> void : confirm_delete_panel.hide()

func _on_delete_pressed() -> void : confirm_delete_panel.show()
