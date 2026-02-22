extends State
@onready var character: character_mesh = $"../../The Lost Sinner1"
@onready var player: player_character = $"../.."

func physics_update(_delta) -> void:
	pass
func attack_logic()->void:
	character.attacking("normal","Hammer","attack_1")
	
