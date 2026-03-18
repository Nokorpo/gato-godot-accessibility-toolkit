extends HBoxContainer
## Lets the user choose whether to use a joystick or keyboard keys for an input action 2D

var use_joystick := false

func _on_button_pressed() -> void:
	if use_joystick:
		use_joystick = false
		$Label.text = "Keyboard"
		$"../../ActionContainer".show()
		$"../../JoystickContainer".hide()
	else:
		use_joystick = true
		$Label.text = "Joystick"
		$"../../ActionContainer".hide()
		$"../../JoystickContainer".show()


func _on_navigation_container_input(event: InputEvent) -> void:
	if event.is_pressed() and (event.is_action("ui_left") or event.is_action("ui_right")):
		_on_button_pressed()
