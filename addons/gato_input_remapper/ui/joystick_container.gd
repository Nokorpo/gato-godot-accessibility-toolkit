## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A Control node that allows configuring a joystick for input. It lets the player
## select between using the left or right joystick, as well as whether de vertical
## direction will be inverted or not.
extends VBoxContainer

@onready var _accept_audio: AudioStreamPlayer = %AcceptAudioStreamPlayer

## Reference to the InputRemapperUI Control node.
var input_remapper_ui: InputRemapperUI
## Name of the action this Control represents.
var action_name: StringName:
	set(value):
		action_name = value
		if input_action:
			# Since the parent "2d_input_map.gd" is the one setting up the
			# action name, we don't know before input_action creation and it
			# needs to be set up now
			input_action.name = value
## Reference to the InputAction this node represents
var input_action: JoystickInputAction2D

func _ready() -> void:
	%JoystickSelector.joystick_container = self
	%InvertDirection.joystick_container = self
	%JoystickSelector.value_changed.connect(_on_joystick_selector_changed)
	%InvertDirection.value_changed.connect(_on_invert_direction_changed)
	input_action = JoystickInputAction2D.new()

func _on_joystick_selector_changed(use_right_joystick: bool) -> void:
	_set_use_right_joystick(use_right_joystick)
	_accept_audio.play()

func _on_invert_direction_changed(invert_joystick: bool) -> void:
	_set_invert(invert_joystick)
	_accept_audio.play()

func _set_use_right_joystick(use_right_joystick: bool) -> void:
	%JoystickSelector.set_stick_text(use_right_joystick)
	%JoystickSelector.use_right_joystick = use_right_joystick
	input_action.use_right_joystick = use_right_joystick
	set_action()

func _set_invert(invert_joystick: bool) -> void:
	%InvertDirection.button_pressed = invert_joystick
	input_action.invert_joystick = invert_joystick
	set_action()

## Reacts to the `GatoInputRemapper.control_scheme_changed` signal to populate the UI with the
## loaded control scheme and propagates it down to its descendants so they can do the same.
func update_ui(_input_action: JoystickInputAction2D) -> void:
	input_action = _input_action
	_set_use_right_joystick(input_action.use_right_joystick)
	_set_invert(input_action.invert_joystick)

## Applies the configuration change on this node to the control scheme
func set_action() -> void:
	input_remapper_ui.set_action2d(action_name, input_action)
