extends HBoxContainer

signal value_changed(new_value: bool)

var input_remapper_ui: InputRemapperUI
var action_name: StringName
var joystick_container

var button_pressed: bool:
	set(value):
		button_pressed = value
		$Button.button_pressed = value

func update_ui(input_action: JoystickInputAction2D) -> void:
	$Button.button_pressed = input_action.invert_joystick

func _on_confirm_pressed() -> void:
	var new_value: bool = !$Button.button_pressed
	_on_button_toggled(new_value)
	value_changed.emit(new_value)

func _on_button_toggled(toggled_on: bool) -> void:
	button_pressed = toggled_on
	value_changed.emit(toggled_on)
