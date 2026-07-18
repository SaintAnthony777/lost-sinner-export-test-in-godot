class_name item_shower extends PanelContainer
@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var item_got : Inventory_Item 
@onready var item_used : String 
@onready var custom_style_box_panel : StyleBoxFlat = StyleBoxFlat.new()
@onready var label : Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	show_item()
func show_item() -> void:
	if item_got:
		if item_got.category == "object":
			set_borders("ffffff")
			label.text="You got "+item_got.item_name
		else : 
			label.text="You got the "+item_got.item_name
			if item_got.category=="grace":
				set_borders("5eeab1")
			if item_got.category=="divine divider":
				set_borders("e7182a")
			if item_got.category=="key":
				set_borders("bfc300")
	elif item_used:
		set_borders("ffffff")
		label.text="Used the "+item_used
	self.add_theme_stylebox_override("panel",custom_style_box_panel)
	await get_tree().create_timer(3.0,true,false,true).timeout
	animation_player.play("RESET")
	animation_player.play("Fade Away")
	await animation_player.animation_finished
	queue_free()
func set_borders(color_entered:String) -> void:
	custom_style_box_panel.border_color=Color.html(color_entered)
	custom_style_box_panel.border_blend=true
	custom_style_box_panel.draw_center=false
	custom_style_box_panel.bg_color=Color(1.0,1.0,1.0,0.0)
	#custom_style_box_panel.set_border_width_all(3)
	#custom_style_box_panel.set_corner_radius_all(45)
	custom_style_box_panel.bg_color=Color.html("1a1a1a99")
