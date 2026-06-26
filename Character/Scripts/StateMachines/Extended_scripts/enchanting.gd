extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.camera.h_offset=0.0
	print(player.chosen_gift)
	character.show_equipped_weapon()
	enchatement_logic()

func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	player.camera.fov=lerp(player.camera.fov,95.0,.1)
	idle_check()
	
func enchatement_logic()->void:
	character.enchants(player.chosen_gift)
	character.get_aura_by_gift(player.chosen_gift).show()
func idle_check()->void:
	await character.animation_tree.animation_finished
	state_machine.change_state("idle")
func exit() -> void:
	character.get_aura_by_gift(player.chosen_gift).hide()
	player.reset_camera()
