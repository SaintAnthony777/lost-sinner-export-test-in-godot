class_name HurtBoxComponent extends Area3D

@export var health_comp:HealthComponent
@onready var collision_shape:CollisionShape3D=get_node("CollisionShape3D")

func _init() -> void:
	collision_layer=5
	collision_mask=4

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area3D) -> void:
	if area is HitBoxComponent and self.owner!=area.owner and area.untouchable_owner!=owner:
		#print("attack from ",area.owner,"received by ",owner," message from ",area)
		if area.owner.dealt_attack:
			var curr_att:Attack=area.owner.dealt_attack
			var curr_hitspark:hitsparks=load("res://Componenents/Hitsparks/hitsparks_"+curr_att.Nature.to_lower()+".tscn").instantiate()
			owner.get_parent().add_child(curr_hitspark)
			curr_hitspark.global_position=area.global_position
			health_comp.taking_damage(area.owner.dealt_attack)
			health_comp.received_attack=area.owner.dealt_attack
			health_comp.attack_sender=area.owner
