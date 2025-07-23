extends HBoxContainer

var use_left_joystick := true

func _on_button_pressed() -> void:
	if use_left_joystick:
		use_left_joystick = false
		$Label.text = "Right"
	else:
		use_left_joystick = true
		$Label.text = "Left"
