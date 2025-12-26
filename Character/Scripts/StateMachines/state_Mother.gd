extends Node

@export var initial_state : NodePath
@onready var current_state : State = get_node(initial_state)

func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func _on_child_transitioned(new_state_name):
	var new_state = get_node(new_state_name)
	if not new_state : return
	
	current_state.exit()
	new_state.enter()
	current_state = new_state
