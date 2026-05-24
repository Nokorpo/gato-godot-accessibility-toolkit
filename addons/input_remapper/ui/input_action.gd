@tool
extends PanelContainer

signal pressed

const _NORMAL_THEME_TYPE_VARIATION: StringName = &"InputActionNormal"
const _ERROR_THEME_TYPE_VARIATION: StringName = &"InputActionError"

@export var label_text: String:
	set(value):
		set_label(value)
		label_text = value

@export var button_text: String:
	set(value):
		set_button(value)
		button_text = value

func set_label(text: String) -> void:
	$HBoxContainer/Label.text = text

func set_button(text: String) -> void:
	$HBoxContainer/Button.text = text

func _on_button_pressed() -> void:
	pressed.emit()

func set_error_highlight(value: bool) -> void:
	theme_type_variation = _ERROR_THEME_TYPE_VARIATION if value else _NORMAL_THEME_TYPE_VARIATION
