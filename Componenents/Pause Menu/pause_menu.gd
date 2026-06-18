class_name PauseMenu extends Control

@onready var Inventory_UI:inventory_UI=get_tree().get_first_node_in_group("Inventory UI")
@onready var Env_to_edit:WorldEnvironment=get_tree().get_nodes_in_group("World Environnements")[0]
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
