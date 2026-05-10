class_name regular_enemy extends enemy
@onready var aiming_node: Node3D = $"Aiming Node"
@onready var hurtbox:HurtBoxComponent=$HurtBoxComponent
func _ready() -> void:
	hurtbox.area_entered.connect(hurtbox._on_area_entered)
