class_name user_prompt_guide
extends Control
# can interact and all that
@onready var can_interact_container: HBoxContainer = $can_interact_container
@onready var prompt_text: Label = $"can_interact_container/Interaction/Prompt text"


#cannot interact and all that
@onready var unable_to_interact: MarginContainer = $Unable_to_interact
@onready var unable_to_interact_text: Label = $Unable_to_interact/Unable_to_interact_text
