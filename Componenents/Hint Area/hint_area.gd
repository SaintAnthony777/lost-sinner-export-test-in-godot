class_name HintArea
extends Node3D

@export var texture_to_be_shown:Texture2D
@export var hint_text:String

@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var hint: Label3D = $hint_area/Hint
@onready var interacted:=false
@onready var inter_area:interaction_area

func _process(delta: float) -> void:
	if (!interacted and Input.is_action_just_pressed("Action trigger") and !personnage.is_busy and
	 inter_area and inter_area.interact==self):
		personnage.character.user_command_guide.show()
		personnage.character.user_command_guide.tip_text.text=hint_text
		if texture_to_be_shown:
			personnage.character.user_command_guide.button_to_show.texture=texture_to_be_shown


func _on_hint_area_body_exited(body: Node3D) -> void:
		if body is player_character:
			personnage.character.user_command_guide.hide()
