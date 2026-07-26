class_name fireball_enemy
extends Node3D
@onready var fireball_shapecast: ShapeCast3D = $"Fireball shapecast"
@onready var dealt_attack:Attack=Attack.new()
@export var fireball_speed:float
@onready var lifetime : float = 0.0
@onready var fireball_animator: AnimationPlayer = $"fireball animator"

func _ready() -> void:
	dealt_attack.create_attack(
		16.0,
		15.0,
		"Fire",
		1.0,
		.0
	)
func _process(delta: float) -> void:
	lifetime+=delta
	if lifetime > 1.0 or fireball_shapecast.is_colliding():
		fireball_animator.play("blow animation")
		await fireball_animator.animation_finished
		queue_free()
		return
	self.global_position+=transform.basis*Vector3(0.0,0.0,fireball_speed)*delta
