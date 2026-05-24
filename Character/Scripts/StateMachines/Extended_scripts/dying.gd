extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."
func enter() -> void:
	player.can_switch_camera=false
	player.is_locking=false
	player.is_aiming=false
	character.hurt_box_component.collision_shape.disabled=true
	death_tricks()
func death_tricks()->void:
	character.taking_damage("Deadful")
