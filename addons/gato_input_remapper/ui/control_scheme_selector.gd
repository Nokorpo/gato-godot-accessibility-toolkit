## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This is a Control node that shows a list of GatoControlSchemes in the current control scheme
## list. It's used to select the next/previous control schemes on the list and apply them. It also
## has a button to reset the changes made to the current control scheme.
extends Container

@onready var _current_scheme_label: Label = $RowNavigationContainer/HBoxContainer/HBoxContainer/CurrentScheme
@onready var _next_scheme_label: Label = $RowNavigationContainer/HBoxContainer/NextScheme
@onready var _second_next_scheme_label: Label = $RowNavigationContainer/HBoxContainer/NextScheme2
@onready var _joystick_cooldown: Timer = $JoystickCooldownTimer

## Reacts to the `GatoInputRemapper.control_scheme_changed` signal to populate the UI with the
## loaded control scheme and propagates it down to its descendants so they can do the same.
func _update_ui(scheme_list: Array[GatoControlScheme], current_scheme: int) -> void:
	_current_scheme_label.text = scheme_list[current_scheme].name
	_next_scheme_label.text = scheme_list[(current_scheme + 1) % scheme_list.size()].name
	_second_next_scheme_label.text = scheme_list[(current_scheme + 2) % scheme_list.size()].name

func _on_row_navigation_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or _joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_right"):
		_joystick_cooldown.start()
		_load_next_scheme()
	elif event.is_action("ui_left"):
		_joystick_cooldown.start()
		_load_last_scheme()

func _load_next_scheme() -> void:
	InputRemapper.load_next_scheme()

func _load_last_scheme() -> void:
	InputRemapper.load_previous_scheme()

## Resets the changes made to the current control scheme.
func reset_config() -> void:
	InputRemapper.reset_changes()
