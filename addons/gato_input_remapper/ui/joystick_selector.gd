## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A selector that allows the user to select whether the action uses the
## left or right joystick.
extends HBoxContainer

## Emitted when the selected joystick changes. The `use_right_joystick` parameter
## is `true` when the right joystick is used, `false` when the left joystick is used.
signal value_changed(use_right_joystick: bool)

## Timer that limits the speed of this selector when using a joystick. This is used
## because otherwise Godot logs dozens of joystick motion events every second and it's
## impossible to select the value you want.
@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

## Reference to the JoystickContainer Control parent of this Control.
var joystick_container
## Whether the left joystick is used (`false`) or the right joystick (`true`).
var use_right_joystick := false

func _on_row_navigation_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_left") or event.is_action("ui_right"):
		joystick_cooldown.start()
		toggle()

## Switch selection between left and right joystick.
func toggle() -> void:
	use_right_joystick = !use_right_joystick
	set_stick_text(use_right_joystick)
	value_changed.emit(use_right_joystick)

func _on_button_pressed() -> void:
	toggle()

## Set the correct text depending on whether the left (`false`) or the
## right (`true`).
func set_stick_text(use_right: bool) -> void:
	if use_right:
		$Label.text = "joystick_right"
	else:
		$Label.text = "joystick_left"
