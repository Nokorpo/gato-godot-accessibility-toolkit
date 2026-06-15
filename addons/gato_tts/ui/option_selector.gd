## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends HBoxContainer

signal selection_changed(option: StringName)

@export var options: Array[StringName] = []:
	set(value):
		options = value
		_current_selection = 0
		if is_instance_valid(label):
			label.text = options[_current_selection]

@onready var label: Label = $Label
@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

var _current_selection: int = 0

func _ready() -> void:
	label.text = options[_current_selection]

func _on_navigation_container_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_left"):
		joystick_cooldown.start()
		_on_left_button_pressed()
	elif event.is_action("ui_right"):
		joystick_cooldown.start()
		_on_right_button_pressed()

func _on_left_button_pressed() -> void:
	var index: int = _current_selection - 1
	_current_selection = posmod(index, options.size())
	label.text = options[_current_selection]
	selection_changed.emit(options[_current_selection])

func _on_right_button_pressed() -> void:
	var index: int = _current_selection + 1
	_current_selection = posmod(index, options.size())
	label.text = options[_current_selection]
	selection_changed.emit(options[_current_selection])
