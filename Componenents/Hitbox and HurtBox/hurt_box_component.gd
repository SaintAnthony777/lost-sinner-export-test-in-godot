class_name HurtBoxComponent extends Area3D

@export var health_comp:HealthComponent
@onready var collision_shape:CollisionShape3D=get_node("CollisionShape3D")
@onready var dist_rect:PackedScene=preload("res://Componenents/Circular distorsion node/Circular distorsion.tscn")

func _init() -> void:
	collision_layer=5
	collision_mask=4

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area3D) -> void:
	if area is HitBoxComponent and self.owner!=area.owner and area.untouchable_owner!=owner:
		if health_comp.is_invulnerable:return
		#print("attack from ",area.owner,"received by ",owner," message from ",area)
		if area.owner.dealt_attack:
			
			var curr_att:Attack=area.owner.dealt_attack
			var pos : Vector3
			
			if owner is EnemyVisuals or owner is character_mesh :
				owner.get_parent().velocity=Vector3.ZERO
				if !owner.is_alive:return
				if owner.is_alive:
					owner.being_hit.emit()
				
			if curr_att.Nature!="Divine Divider" and curr_att.Nature!="Grace" and curr_att.Nature!="": 
				var curr_hitspark:hitsparks=load("res://Componenents/Hitsparks/hitsparks_"+curr_att.Nature.to_lower()+".tscn").instantiate()
				owner.get_parent().add_child(curr_hitspark)
				curr_hitspark.global_position=area.global_position
				pos = area.global_position
			else : 
				pos = self.global_position
			var distorsion_rect:circular_distorsion=dist_rect.instantiate()
			
			distorsion_rect.force=.2
			distorsion_rect.thickness=2.0
			distorsion_rect.given_center=get_viewport().get_camera_3d().unproject_position(pos)
			if curr_att.Strength>=25.0:
				owner.get_parent().add_child(distorsion_rect)
			health_comp.taking_damage(area.owner.dealt_attack)
			health_comp.received_attack=area.owner.dealt_attack
			health_comp.attack_sender=area.owner
