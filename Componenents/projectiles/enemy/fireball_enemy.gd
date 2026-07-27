class_name enemy_projectile
extends Node3D
@onready var fireball_shapecast: ShapeCast3D = $"Fireball shapecast"
@onready var dealt_attack:Attack=Attack.new()
@export var fireball_speed:float
@onready var lifetime : float = 0.0
@onready var fireball_animator: AnimationPlayer = $"fireball animator"
@export var damage:float
@export var nature:String
@export var curr_hitbox:HitBoxComponent
@export var attack_direction:String

func _ready() -> void:
	dealt_attack.create_attack(
		damage,
		15.0,
		nature,
		1.0,
		.0
	)
	curr_hitbox.collsion_shape.disabled=false

func _process(delta: float) -> void:
	lifetime+=delta
	fireball_shapecast.force_shapecast_update()
	if lifetime > 1.0 or fireball_shapecast.is_colliding():
		fireball_animator.play("blow animation")
		await fireball_animator.animation_finished
		queue_free()
		return
	self.global_position+=transform.basis*Vector3(0.0,0.0,fireball_speed)*delta
