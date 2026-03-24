extends HBoxContainer

signal value_changed(new_value: bool)

var joystick_container
var use_right_joystick := false

func _on_row_navigation_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action("ui_left") or event.is_action("ui_right"):
			use_right_joystick = !use_right_joystick
			set_stick(use_right_joystick)
			value_changed.emit(use_right_joystick)

func _on_button_pressed() -> void:
	use_right_joystick = !use_right_joystick
	set_stick(use_right_joystick)
	value_changed.emit(use_right_joystick)

func set_stick(use_right: bool) -> void:
	if use_right:
		#use_right_joystick = false
		$Label.text = "Right"
	else:
		#use_right_joystick = true
		$Label.text = "Left"
