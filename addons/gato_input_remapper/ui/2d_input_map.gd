## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A Control that let's the user choose whether to use a joystick (JoystickInputAction2D)
## or keys/controller buttons (KeysInputAction2D) for an input action 2D. It also allows
## configuring the joystick or keys/buttons used for this input.
extends Control

## Emitted when the current configuration has 2 or more actions using the same InputEvent
## as a trigger.
signal detected_conflicting_inputs(input_action_list: Array[InputAction])

## Reference to the InputRemapperUI Control node.
@export var input_remapper_ui: InputRemapperUI
## Name of the action this Control represents.
@export var action_name: StringName
## Reference to the dialog that shows up when listening for `InputEvents`.
@export var press_key_dialog: Control

func _ready() -> void:
	%ActionContainer.press_key_dialog = press_key_dialog
	%ActionContainer.action_name = action_name
	%ActionContainer.input_remapper_ui = input_remapper_ui
	detected_conflicting_inputs.connect(%ActionContainer.on_detected_conflicting_inputs)
	%JoystickContainer.action_name = action_name
	%JoystickContainer.input_remapper_ui = input_remapper_ui
	if input_remapper_ui:
		input_remapper_ui.detected_conflicting_inputs.connect(_on_detected_conflicting_inputs)

## Reacts to the `GatoInputRemapper.control_scheme_changed` signal to populate the UI with the
## loaded control scheme and propagates it down to its descendants so they can do the same.
func update_ui(scheme: GatoControlScheme) -> void:
	for input_action in scheme.input_actions:
		if input_action.name != action_name:
			continue
		if input_action is JoystickInputAction2D:
			%JoystickToggle.use_joystick = true
			%JoystickToggle.update_ui()
			%JoystickContainer.update_ui(input_action)
		elif input_action is KeysInputAction2D:
			%JoystickToggle.use_joystick = false
			%JoystickToggle.update_ui()
			%ActionContainer.update_ui(input_action)

func _on_detected_conflicting_inputs(input_action_list: Array[InputAction]):
	detected_conflicting_inputs.emit(input_action_list)
