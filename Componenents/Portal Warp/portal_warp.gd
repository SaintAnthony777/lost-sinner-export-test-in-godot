class_name portal_warp extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interacted:bool=false
@onready var inter_area: interaction_area = $interaction_area
@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")


@export var destination_scene:String
@export var destination_location:Vector3

func _process(delta: float) -> void:
	if (!interacted and Input.is_action_just_pressed("Action trigger") and
		 inter_area and inter_area.interact==self and personnage.character.interacts):
			interacted=true
			SaveManager.specific_save(
				personnage,
				destination_location,
				destination_scene
			)
			animation_player.play("warping")
			var white_screen_loaded:white_screen=load("res://Componenents/Whitescreen_fade/white_screen_fading.tscn").instantiate()
			self.add_child(white_screen_loaded)
