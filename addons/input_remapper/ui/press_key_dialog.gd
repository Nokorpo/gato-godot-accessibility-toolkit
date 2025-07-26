extends Control

signal input_read(input: InputEventKey)

var reading_input: bool = false

func start_reading_input():
	reading_input = true
	show()

func _input(event: InputEvent) -> void:
	if reading_input and event is InputEventKey:
		input_read.emit(event)
		reading_input = false
		hide()
