extends State

@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	player.is_busy=true
	player.camera.v_offset=-.4
	player.camera.fov=85.0
	character.look_at(player.player_look_node.global_position)
	character.rotate_y(PI)
	SaveManager.save_game(player)
	SaveManager.restor_health_and_arcane(player)
	sitting_ready_logics()
	
func physics_update(_delta) -> void:
	player.camera_rotation_logic(_delta)
	await character.animation_tree.animation_finished
	state_machine.change_state("sitting idle")
func sitting_ready_logics()->void:
	character.interaction_motion("Starts sitting")
	
