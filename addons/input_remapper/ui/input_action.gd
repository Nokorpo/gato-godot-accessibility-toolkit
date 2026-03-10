@tool
extends HBoxContainer

signal pressed

@export var label_text: String:
	set(value):
		set_label(value)
		label_text = value

@export var button_text: String:
	set(value):
		set_button(value)
		button_text = value

func set_label(text: String) -> void:
	$Label.text = text

func set_button(text: String) -> void:
	$Button.text = text

func _on_button_pressed() -> void:
	pressed.emit()
