class_name menu_button extends Button

func _process(delta: float) -> void:
	if self.is_hovered():
		self.grab_focus()
