extends Control

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
	if event is InputEventKey or event is InputEventJoypadButton:
		input_read.emit(event)
		reading_input = false
		hide()
