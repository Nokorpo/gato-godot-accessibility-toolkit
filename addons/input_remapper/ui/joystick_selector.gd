extends HBoxContainer

var input_action: JoystickInputAction2D
var use_right_joystick := false

func update_ui(_input_action: JoystickInputAction2D) -> void:
	input_action = _input_action
	set_stick(input_action.use_right_joystick)

func _on_button_pressed() -> void:
	set_stick(use_right_joystick)

func set_stick(use_right: bool) -> void:
	if use_right:
		use_right_joystick = false
		input_action.use_right_joystick = false
		$Label.text = "Right"
	else:
		use_right_joystick = true
		input_action.use_right_joystick = false
		$Label.text = "Left"
