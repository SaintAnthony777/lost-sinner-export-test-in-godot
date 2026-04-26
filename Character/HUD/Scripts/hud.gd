extends Control


@onready var player:player_character=get_parent().get_parent().get_parent()
@onready var Divine_divider:=$"Divine Divider"
@onready var Grace:=$"Grace actuelle"
var current_divine_divider_icon:CompressedTexture2D
var current_grace_icon:CompressedTexture2D


func _ready() -> void:
	pass
func _process(delta: float) -> void:
	if player.current_divine_divider:
		current_divine_divider_icon=load("res://Character/HUD/assets/icons/"+player.current_divine_divider+".png")
		Divine_divider.texture=current_divine_divider_icon
	if player.current_grace:
		current_grace_icon=load("res://Character/HUD/assets/icons/"+player.current_grace+".png")
		Grace.texture=current_grace_icon
