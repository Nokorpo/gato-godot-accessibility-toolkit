## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## Control node that represents an `InputAction` as a `Label` and `Button`.
## The `Label` shows the `InputAction`'s name, while the `Button` shows its
## triggering key or button.
##
## The `Button` also allows re-configuring the triggering key or button by
## pressing on it. A dialog that listens to key presses should show up when
## clicking on it.
@tool
extends PanelContainer

## Emitted when the button is pressed. In the example UI, this signal is
## used to show the "waiting for input" dialog.
signal pressed

const _NORMAL_THEME_TYPE_VARIATION: StringName = &"InputActionNormal"
const _ERROR_THEME_TYPE_VARIATION: StringName = &"InputActionError"

## The text for the `Label` that shows the `InputAction`'s name.
@export var label_text: String:
	set(value):
		set_label(value)
		label_text = value

## The text for the `Button` that shows the `InputAction`'s triggering event.
@export var button_text: String:
	set(value):
		set_button(value)
		button_text = value

## Sets the text for the `Label` that shows the `InputAction`'s name.
func set_label(text: String) -> void:
	$HBoxContainer/Label.text = text

## Sets the text for the `Button` that shows the `InputAction`'s triggering event.
func set_button(text: String) -> void:
	$HBoxContainer/Button.text = text

func _on_button_pressed() -> void:
	pressed.emit()

## Used to highlight this Control as having an error (`true`) or not (`false`).
## As of this moment, this is only used when multiple `InputAction` objects use
## the same triggering `InputEvent`.
func set_error_highlight(value: bool) -> void:
	theme_type_variation = _ERROR_THEME_TYPE_VARIATION if value else _NORMAL_THEME_TYPE_VARIATION
