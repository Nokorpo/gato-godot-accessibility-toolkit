## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This is a Control node that contains a dialog to be shown when the input remapper
## is waiting for an input.
extends Control

## There are some keys that cannot be used, like the ESC key that is used to cancel the
## selection, or the meta, control, alt and shift keys, that are used as modifiers.
const EXCLUDED_KEYS := [KEY_ENTER, KEY_ESCAPE, KEY_META, KEY_CTRL, KEY_SHIFT, KEY_ALT]

## Emitted when the dialog shows up
signal started_reading_input
## Emitted when a key is pressed. The `result` parameter includes either an InputEvent
## representing the key pressed or a canceled notification.
signal input_read(result: InputReadResult)

## Whether the node is reading input (true) or not (false.
var reading_input: bool = false

## A class that represents the result of an input reading. It should return an object
## whose `event` property is not empty, or one whose `canceled` property is set to `true`
## and the `event` property set to `null`.
class InputReadResult:
	## The InputEvent that was detected.
	var event: InputEventKey
	## Whether the input reading was canceled (`true`) or successfull (`false`).
	var canceled: bool = false
	func _init(_event: InputEventKey, _canceled: bool = false) -> void:
		event = _event
		canceled = _canceled

## Tells the node to show the dialog up and start listening for input.
func start_reading_input():
	reading_input = true
	started_reading_input.emit()
	show()

func _input(event: InputEvent) -> void:
	if not reading_input:
		return
	if not event.is_pressed():
		return
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			input_read.emit(InputReadResult.new(null, true))
			reading_input = false
			hide()
			return
		elif event.keycode in EXCLUDED_KEYS:
			return
	if event is InputEventKey or event is InputEventJoypadButton:
		input_read.emit(InputReadResult.new(event, false))
		reading_input = false
		hide()
