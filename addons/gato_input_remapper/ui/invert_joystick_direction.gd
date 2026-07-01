## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A simple checkbox that allows inverting the vertical direction of the joystick. If checked, it is
## inverted. If it isn't checked, it's the default orientation.
extends HBoxContainer

signal value_changed(new_value: bool)

## Reference to the InputRemapperUI Control node.
var input_remapper_ui: InputRemapperUI
## Name of the action this Control represents.
var action_name: StringName
## Reference to the JoystickContainer Control parent of this Control.
var joystick_container

## Whether or not the invert joystick checkbox is checked (true) or not (false).
var button_pressed: bool:
	set(value):
		button_pressed = value
		$Button.button_pressed = value

## Reacts to the `GatoInputRemapper.control_scheme_changed` signal to populate the UI with the
## loaded control scheme and propagates it down to its descendants so they can do the same.
func update_ui(input_action: JoystickInputAction2D) -> void:
	$Button.button_pressed = input_action.invert_joystick

func _on_confirm_pressed() -> void:
	var new_value: bool = !$Button.button_pressed
	_on_button_toggled(new_value)
	value_changed.emit(new_value)

func _on_button_toggled(toggled_on: bool) -> void:
	button_pressed = toggled_on
	value_changed.emit(toggled_on)
