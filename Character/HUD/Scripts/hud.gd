extends Control


@onready var player:player_character=get_parent().get_parent().get_parent()
@onready var divine_divider: TextureRect = $"Health and equip/Divine divider"
@onready var grace: TextureRect = $"Health and equip/Grace"




func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	if player.current_divine_divider:
		var divine_divider_texture:=load("res://Character/HUD/assets/Icones equipement/Divines dividers/"+player.current_divine_divider+".PNG")
		divine_divider.texture=divine_divider_texture
	if player.current_grace:
		grace.texture=load("res://Character/HUD/assets/Icones equipement/Graces/"+player.current_grace+".PNG")
