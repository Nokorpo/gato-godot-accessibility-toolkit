## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A Control that lets the user configure the keys or controller buttons used
## for a `KeysInputAction2D`.
extends VBoxContainer

@onready var _accept_audio: AudioStreamPlayer = %AcceptAudioStreamPlayer
@onready var _cancel_audio: AudioStreamPlayer = %CancelAudioStreamPlayer

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
var input_action: KeysInputAction2D
## Whether or not the control is currently waiting for an input (true) or not (false).
var reading_input: bool = false
## Reference to the dialog that shows up when listening for `InputEvents`.
var press_key_dialog: Control

func _ready() -> void:
	input_action = KeysInputAction2D.new()

## Reacts to the `GatoInputRemapper.control_scheme_changed` signal to populate the UI with the
## loaded control scheme and propagates it down to its descendants so they can do the same.
func update_ui(_input_action: KeysInputAction2D) -> void:
	input_action = _input_action

	%UpInputAction.button_text = input_action.up.as_text_keycode()
	%UpInputAction.set_error_highlight(false)
	%DownInputAction.button_text = input_action.down.as_text_keycode()
	%DownInputAction.set_error_highlight(false)
	%LeftInputAction.button_text = input_action.left.as_text_keycode()
	%LeftInputAction.set_error_highlight(false)
	%RightInputAction.button_text = input_action.right.as_text_keycode()
	%RightInputAction.set_error_highlight(false)

func _read_event_or_null() -> InputEventKey:
	_accept_audio.play()
	press_key_dialog.start_reading_input()
	var result = await press_key_dialog.input_read
	if result.canceled:
		_cancel_audio.play()
		return
	_accept_audio.play()
	return result.event

func _on_button_up_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%UpInputAction.button_text = event.as_text_keycode()
		%UpInputAction.set_error_highlight(false)
		input_action.up = event
		set_action()

func _on_button_down_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%DownInputAction.button_text = event.as_text_keycode()
		%DownInputAction.set_error_highlight(false)
		input_action.down = event
		set_action()

func _on_button_left_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%LeftInputAction.button_text = event.as_text_keycode()
		%LeftInputAction.set_error_highlight(false)
		input_action.left = event
		set_action()

func _on_button_right_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%RightInputAction.button_text = event.as_text_keycode()
		%RightInputAction.set_error_highlight(false)
		input_action.right = event
		set_action()

func set_action():
	input_remapper_ui.set_action2d(action_name, input_action)

func on_detected_conflicting_inputs(input_action_list: Array[InputAction]) -> void:
	for conflicting_action: InputAction in input_action_list:
		if conflicting_action.contains_input_event(input_action.up):
			%UpInputAction.set_error_highlight(true)
		elif conflicting_action.contains_input_event(input_action.down):
			%DownInputAction.set_error_highlight(true)
		elif conflicting_action.contains_input_event(input_action.left):
			%LeftInputAction.set_error_highlight(true)
		elif conflicting_action.contains_input_event(input_action.right):
			%RightInputAction.set_error_highlight(true)
