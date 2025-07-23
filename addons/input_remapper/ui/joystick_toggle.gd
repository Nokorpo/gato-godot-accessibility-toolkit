extends HBoxContainer

var use_joystick := false

func _on_button_pressed() -> void:
	if use_joystick:
		use_joystick = false
		$Label.text = "Keyboard"
		$"../ActionContainer".show()
		$"../JoystickSelector".hide()
	else:
		use_joystick = true
		$Label.text = "Joystick"
		$"../ActionContainer".hide()
		$"../JoystickSelector".show()
