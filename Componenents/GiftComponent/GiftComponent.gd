class_name GiftComponent extends Node


@export var max_gift:float
@export var gift_gauge:TextureProgressBar

@onready var is_consummed:bool=false

var current_gift_lvl:float
var gift_consumed_lvl:float=.8
var can_be_consumed:bool=false

func _ready() -> void: 
	current_gift_lvl=max_gift

func _process(delta: float) -> void:
	gift_gauge.value=lerp(gift_gauge.value,current_gift_lvl,.5)
	if current_gift_lvl<=25.0 : can_be_consumed=false
	else : can_be_consumed=true
	
	if is_consummed:
		can_be_consumed = false
		gift_consumption(gift_consumed_lvl)

func gift_consumption(gift_consumed)->void:
	current_gift_lvl-=gift_consumed
	if current_gift_lvl < 0:
		current_gift_lvl = 0
		is_consummed = false
