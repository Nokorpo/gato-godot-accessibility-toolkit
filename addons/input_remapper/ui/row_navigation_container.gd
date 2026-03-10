extends MarginContainer

signal pressed

var _just_released: bool = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and has_focus():
		if event.pressed and _just_released:
			_just_released = false
			pressed.emit()
		elif not event.pressed:
			_just_released = true

	else:
		if event.is_action("ui_accept") and has_focus():
			pressed.emit()

func _on_mouse_entered() -> void:
	grab_focus()

func _on_mouse_exited() -> void:
	release_focus()

func _on_focus_entered() -> void:
	$Panel.show()

func _on_focus_exited() -> void:
	$Panel.hide()
