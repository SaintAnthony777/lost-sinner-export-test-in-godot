extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

var sprinting_speed:=9.0

func physics_update(_delta) -> void:
	state_logic(_delta)
	if Input.is_action_just_released("sprinting"):state_machine.change_state("normal")
func state_logic(delta:float)->void:
	player.SPEED=sprinting_speed
	player.gravity_applying()
	player.camera_rotation_logic(delta)
	player.character_moving(player.player_direction)
	player.character_rotation(player.player_move_direction,player.last_movement_direction,delta)
	character.sprinting()
