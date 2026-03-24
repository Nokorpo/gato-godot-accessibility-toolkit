extends HBoxContainer
## Lets the user choose whether to use a joystick or keyboard keys for an input action 2D

var use_joystick := false

func _on_button_pressed() -> void:
	use_joystick = !use_joystick
	update_ui()

func update_ui() ->void :
	if use_joystick:
		$Label.text = "Joystick"
		focus_neighbor_bottom = ^"../../JoystickContainer/UpRowNavigationContainer3"
		%ActionContainer.hide()
		%JoystickContainer.show()
		%JoystickContainer.set_action()

	else:
		$Label.text = "Keyboard"
		focus_neighbor_bottom = ^"../../JoystickContainer/UpRowNavigationContainer2"
		%ActionContainer.show()
		%JoystickContainer.hide()
		%ActionContainer.set_action()

func _on_navigation_container_input(event: InputEvent) -> void:
	if event.is_pressed() and (event.is_action("ui_left") or event.is_action("ui_right")):
		_on_button_pressed()
