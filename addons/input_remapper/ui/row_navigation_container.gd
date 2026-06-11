## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name RowNavigationContainer
extends MarginContainer

signal pressed
signal input(event: InputEvent)

var _just_released: bool = true

func _input(event: InputEvent) -> void:
	if not has_focus():
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _just_released:
			_just_released = false
			pressed.emit()
		elif not event.pressed:
			_just_released = true

	elif event.is_pressed() and event.is_action("ui_accept"):
			pressed.emit()
	else:
		input.emit(event)

func _on_mouse_entered() -> void:
	print("mouse enter")
	grab_focus()

func _on_mouse_exited() -> void:
	print("mouse exit")
	release_focus()

func _on_focus_entered() -> void:
	$Panel.show()

func _on_focus_exited() -> void:
	$Panel.hide()
