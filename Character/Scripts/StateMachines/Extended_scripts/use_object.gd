extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
@onready var object_particle:evergreen_particles=evergreen_particles.new()
@onready var particles:PackedScene
func enter() -> void:
	character.use_regen_Item(player.used_item.item_name)
	particles=load("res://Componenents/evergreen particles/"+player.used_item.item_name+"_particles.tscn")
func physics_update(_delta) -> void:
	player.camera.fov=lerp(player.camera.fov,95.0,.1)
	healing_factor_check()
	heal_to_idle_check()
	player.camera_rotation_logic(_delta)
	
func healing_factor_check()->void:
	if character.is_healing:
		character.healing_particles.add_child(particles.instantiate())
		character.is_healing=false
		player.player_inventory.substract_item(player.used_item,1)
		character.healing_factor(player.used_item)

func heal_to_idle_check()->void:
	await character.animation_tree.animation_finished 
	state_machine.change_state("idle")
