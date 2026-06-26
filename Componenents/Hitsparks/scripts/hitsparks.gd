class_name hitsparks extends Node3D
@export var hit_spark_nature:String

@onready var hitsparks_parent: hitsparks = $"."
@onready var sparks: GPUParticles3D = $Sparks

func _ready() -> void:
	sparks.emitting=true
func _on_effects_finished() -> void:
	hitsparks_parent.queue_free()
