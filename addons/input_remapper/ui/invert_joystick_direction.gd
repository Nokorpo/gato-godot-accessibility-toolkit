extends HBoxContainer

var input_remapper_ui: InputRemapperUI
var action_name: StringName
var input_action: JoystickInputAction2D

func update_ui(_input_action: JoystickInputAction2D) -> void:
	input_action = _input_action
	$Button.button_pressed = input_action.invert_joystick

func _on_confirm_pressed() -> void:
	_on_button_toggled(!$Button.button_pressed)

func _on_button_toggled(toggled_on: bool) -> void:
	input_action.invert_joystick = toggled_on
	input_remapper_ui.set_action2d(action_name, input_action)
