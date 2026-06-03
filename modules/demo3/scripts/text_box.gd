extends PanelContainer

signal pressed

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton \
		and event.is_pressed() \
		and event.button_index == MOUSE_BUTTON_LEFT:
			pressed.emit()

func set_text(text: String) -> void:
	$MarginContainer/Label.text = text
