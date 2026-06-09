## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
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
