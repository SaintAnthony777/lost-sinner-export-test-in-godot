extends Weapon
@onready var anim_player:AnimationPlayer=$"AnimationPlayer"
func _ready() -> void:
	anim_player.play("Light_flickers")
