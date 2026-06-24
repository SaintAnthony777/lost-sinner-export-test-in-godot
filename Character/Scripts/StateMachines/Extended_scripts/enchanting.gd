extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func enter() -> void:
	print(player.chosen_gift)
