extends Boss_Root

@onready var boss_name: Label = $"HealthBar canvas/Boss Hud/MarginContainer2/Boss Name"
@onready var Halfrey:Boss_Visuals=$"Halfrey"

func _ready() -> void:
	Boss_name="Halfrey, The Fallen Brave"
	initialize_aiming_node()
	initialize_player()
	boss_name.text=Boss_name
func _process(delta: float) -> void:
	if Halfrey.is_ready:Boss_hud.show()
	check_if_aimed_at()
