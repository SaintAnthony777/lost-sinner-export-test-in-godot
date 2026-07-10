class_name circular_distorsion extends Control

@onready var distors_rect: ColorRect = $ColorRect
@onready var given_center:Vector2
@onready var force:float=0.05
@onready var thickness:float=0.1
@onready var distorsion_material:ShaderMaterial=ShaderMaterial.new()
@onready var distorded_animator: AnimationPlayer = $"distorded animator"
@onready var speed_given:float=1.0

func _ready() -> void: 
	distorsion_material = distors_rect.material
	var normalized_center=given_center/(get_viewport().get_visible_rect().size)
	distorsion_material.set_shader_parameter("center",normalized_center)
	distorsion_material.set_shader_parameter("Force",force)
	distorsion_material.set_shader_parameter("Thickness",thickness)
	distorded_animator.play("RESET")
	distorded_animator.speed_scale=speed_given
	distorded_animator.play("distords")
	await distorded_animator.animation_finished
	queue_free()
