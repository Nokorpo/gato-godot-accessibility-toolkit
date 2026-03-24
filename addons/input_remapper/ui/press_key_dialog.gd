extends Control

const EXCLUDED_KEYS := [KEY_ENTER, KEY_ESCAPE, KEY_META, KEY_CTRL, KEY_SHIFT, KEY_ALT]

signal input_read(input: InputEventKey)

var reading_input: bool = false

func start_reading_input():
	reading_input = true
	show()

func _input(event: InputEvent) -> void:
	if not reading_input:
		return
	if not event.is_pressed():
		return
	if event is InputEventKey and event.keycode in EXCLUDED_KEYS:
		return
	if event is InputEventKey or event is InputEventJoypadButton:
		input_read.emit(event)
		reading_input = false
		hide()
