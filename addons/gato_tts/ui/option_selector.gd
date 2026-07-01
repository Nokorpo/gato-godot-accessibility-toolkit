## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This node is a selector can be configured to choose between multiple
## options with a controller.
extends HBoxContainer

## Emitted when the selected option is changed. The parameter `option`
## is the name of the selected option.
signal selection_changed(option: StringName)

## List of all possible options in this selector. The list is not
## changed by the node to allow the developer to order the list as
## needed. If you want it sorted, sort it before setting this value.
@export var options: Array[StringName] = []:
	set(value):
		options = value
		_current_selection = 0
		if is_instance_valid(label):
			label.text = options[_current_selection]

## A reference to the Label node that shows the currently selected option.
@onready var label: Label = $Label
## Timer that limits the speed of this selector when using a joystick. This is used
## because otherwise Godot logs dozens of joystick motion events every second and it's
## impossible to select the value you want.
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
