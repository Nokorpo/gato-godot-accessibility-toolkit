extends GridContainer

var input_action: KeysInputAction2D
var reading_input: bool = false
var press_key_dialog: Control

func update_ui(_input_action: KeysInputAction2D) -> void:
	input_action = _input_action
	$ButtonUp.text = input_action.up.as_text_keycode()
	$ButtonDown.text = input_action.down.as_text_keycode()
	$ButtonLeft.text = input_action.left.as_text_keycode()
	$ButtonRight.text = input_action.right.as_text_keycode()

func _on_button_up_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	$ButtonUp.text = event.as_text_keycode()

func _on_button_down_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	$ButtonDown.text = event.as_text_keycode()

func _on_button_left_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	$ButtonLeft.text = event.as_text_keycode()

func _on_button_right_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	$ButtonRight.text = event.as_text_keycode()
