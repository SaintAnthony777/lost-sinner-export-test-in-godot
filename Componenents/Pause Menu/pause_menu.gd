class_name PauseMenu extends Control

@onready var Inventory_UI:inventory_UI=get_tree().get_first_node_in_group("Inventory UI")
@onready var Env_to_edit:WorldEnvironment=get_tree().get_nodes_in_group("World Environnements")[0]
@onready var playernode:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var confirm_quit_desktop: VBoxContainer = $Confirm_quit_desktop
@onready var confirm_quit_to_main_menu: VBoxContainer = $Confirm_quit_to_main_menu
@onready var buttons_Vbox_container: VBoxContainer = $"Buttons container/VBoxContainer"

func _ready() -> void:
	print(Env_to_edit)
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause") and !Inventory_UI.visible:
		show_and_hide_pause()
func show_and_hide_pause()->void:
	if self.visible:
		get_tree().paused = false ; Input.mouse_mode=Input.MOUSE_MODE_CAPTURED ;
	else : 
		get_tree().paused = true ; Input.mouse_mode=Input.MOUSE_MODE_VISIBLE ; 
	self.visible=!self.visible


func _on_resume_pressed() -> void : 
	get_tree().paused = false ; Input.mouse_mode=Input.MOUSE_MODE_CAPTURED ; self.hide()


func _on_quit_to_main_menu_pressed() -> void:
	show_and_hide(buttons_Vbox_container,confirm_quit_to_main_menu)
func _on_yes_main_menu_pressed() -> void:
	get_tree().paused=false
	SaveManager.save_game(playernode)
	get_tree().change_scene_to_file("res://Componenents/MainScreenUI/main_screen_ui.tscn")
func show_and_hide(box1:Control,box2:Control):
	box1.hide()
	box2.show()


func _on_quit_to_desktop_pressed() -> void:
	show_and_hide(buttons_Vbox_container,confirm_quit_desktop)
func _on_no_main_menu_pressed() -> void:
	show_and_hide(confirm_quit_to_main_menu,buttons_Vbox_container)
func _on_no_desktop_pressed() -> void:
	show_and_hide(confirm_quit_desktop,buttons_Vbox_container)


func _on_yes_desktop_pressed() -> void:
	get_tree().paused=false
	SaveManager.save_game(playernode)
	get_tree().quit()
