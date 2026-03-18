extends VBoxContainer

var input_remapper_ui: InputRemapperUI
var action_name: StringName
var input_action: KeysInputAction2D
var reading_input: bool = false
var press_key_dialog: Control

func _ready() -> void:
	input_action = KeysInputAction2D.new()

func update_ui(_input_action: KeysInputAction2D) -> void:
	input_action = _input_action
	action_name = _input_action.name

	%UpInputAction.button_text = input_action.up.as_text_keycode()
	%DownInputAction.button_text = input_action.down.as_text_keycode()
	%LeftInputAction.button_text = input_action.left.as_text_keycode()
	%RightInputAction.button_text = input_action.right.as_text_keycode()

func _on_button_up_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	%UpInputAction.button_text = event.as_text_keycode()
	input_action.up = event
	set_action()

func _on_button_down_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	%DownInputAction.button_text = event.as_text_keycode()
	input_action.down = event
	set_action()

func _on_button_left_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	%LeftInputAction.button_text = event.as_text_keycode()
	input_action.left = event
	set_action()

func _on_button_right_pressed() -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	%RightInputAction.button_text = event.as_text_keycode()
	input_action.right = event
	set_action()

func set_action():
	input_remapper_ui.set_action2d(action_name, input_action)
