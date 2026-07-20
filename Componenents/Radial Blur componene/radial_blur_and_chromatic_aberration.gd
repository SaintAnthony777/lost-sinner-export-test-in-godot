class_name RadialBlurPlusChromatic
extends Control


@onready var center_3d_given:Vector3
@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var given_speed : float = 1.0
@onready var distorsion_material:ShaderMaterial=ShaderMaterial.new()

func _ready() -> void:
	distorsion_material=color_rect.material
	var divided_center:Vector2=get_viewport().get_camera_3d().unproject_position(center_3d_given)
	var normalized_center:=divided_center/((get_viewport().get_visible_rect().size))
	distorsion_material.set_shader_parameter("center",normalized_center)
	animation_player.play("RESET")
	animation_player.play("Distorsion")
	await animation_player.animation_finished
	queue_free()
