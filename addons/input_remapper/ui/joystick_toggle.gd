extends HBoxContainer
## Lets the user choose whether to use a joystick or keyboard keys for an input action 2D

var use_joystick := false

func _on_button_pressed() -> void:
	if use_joystick:
		use_joystick = false
		$Label.text = "Keyboard"
		$"../ActionContainer".show()
		$"../JoystickContainer".hide()
	else:
		use_joystick = true
		$Label.text = "Joystick"
		$"../ActionContainer".hide()
		$"../JoystickContainer".show()
