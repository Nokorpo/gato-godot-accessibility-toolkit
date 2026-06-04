## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Control

const EXCLUDED_KEYS := [KEY_ENTER, KEY_ESCAPE, KEY_META, KEY_CTRL, KEY_SHIFT, KEY_ALT]

signal started_reading_input
signal input_read(result: InputReadResult)

var reading_input: bool = false

class InputReadResult:
	var event: InputEventKey
	var canceled: bool = false
	func _init(_event: InputEventKey, _canceled: bool = false) -> void:
		event = _event
		canceled = _canceled

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
