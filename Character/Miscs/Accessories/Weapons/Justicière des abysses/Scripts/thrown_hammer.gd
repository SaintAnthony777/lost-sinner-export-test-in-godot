class_name thrown_hammer extends Node3D

@onready var hammer_ray_cast: ShapeCast3D = $Hammer_ray_cast
@onready var hammer_hitbox:HitBoxComponent=$Hammer_hitbox
@onready var player : player_character = get_tree().get_first_node_in_group("Personnage")
@export var attack_nature:String=""
const HAMMER_SPEED:=40.0
var lifetime:=0.0
var returning:bool=false
var dealt_attack:Attack=Attack.new()
var curr_weapon:Weapon=Weapon.new()

@onready var attack_direction:String="down"

func _ready() -> void:
	hammer_ray_cast.set_collision_mask_value(2,true)
	hammer_ray_cast.set_collision_mask_value(3,true)
	hammer_hitbox.untouchable_owner=get_parent().get_node("Personnage").get_node("The Lost Sinner1")
	
	if player.character.gift_component.is_consummed:
		curr_weapon=player.character.get_weapon_by_gift(player.chosen_gift)
		print(curr_weapon.damage_nature)
	else : curr_weapon=player.character.get_weapon_by_gift("Neutral")
	
	dealt_attack.Base_damage=curr_weapon.base_damage+randf_range(0.1,5.0)
	dealt_attack.Nature=curr_weapon.damage_nature
	dealt_attack.Stun_time=curr_weapon.stun_time+randf_range(0.1,4.0)
	dealt_attack.Strength=curr_weapon.strength+randf_range(0.1,3.0)
	hammer_hitbox.collsion_shape.disabled=false
	
func _process(delta: float) -> void:
	hammer_hitbox.collsion_shape.disabled=false
	hammer_ray_cast.force_shapecast_update()
	lifetime+=delta
	if !returning:
		var sweep_distance = HAMMER_SPEED * delta * 1.5
		hammer_ray_cast.target_position = Vector3(0, 0, -sweep_distance)
		global_position+=transform.basis*Vector3(0,0,-HAMMER_SPEED)*delta
		if hammer_ray_cast.is_colliding() or lifetime > 1.0:
			returning=true
	else :
		var direction = (get_parent().get_node("Personnage").hammer_starting_point.global_position-global_position).normalized()
		global_position+=direction*HAMMER_SPEED*delta
		rotate_y(20*delta)
		if global_position.distance_to(get_parent().get_node("Personnage").global_position)<=15.0:
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").play_hammer_sweep()
		if global_position.distance_to(get_parent().get_node("Personnage").global_position)<3.0:
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").equipped_hammer.show()
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").pick_back_hammer=true
			get_parent().get_node("Personnage").get_node("The Lost Sinner1").hammer_last_pos=self.global_position
			await get_tree().process_frame
			queue_free()
