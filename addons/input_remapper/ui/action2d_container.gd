extends VBoxContainer

var input_remapper_ui: InputRemapperUI
var action_name: StringName:
	set(value):
		action_name = value
		if input_action:
			# Since the parent "2d_input_map.gd" is the one setting up the
			# action name, we don't know before input_action creation and it
			# needs to be set up now
			input_action.name = value
var input_action: KeysInputAction2D
var reading_input: bool = false
var press_key_dialog: Control

func _ready() -> void:
	input_action = KeysInputAction2D.new()

func update_ui(_input_action: KeysInputAction2D) -> void:
	input_action = _input_action

	%UpInputAction.button_text = input_action.up.as_text_keycode()
	%UpInputAction.set_error_highlight(false)
	%DownInputAction.button_text = input_action.down.as_text_keycode()
	%DownInputAction.set_error_highlight(false)
	%LeftInputAction.button_text = input_action.left.as_text_keycode()
	%LeftInputAction.set_error_highlight(false)
	%RightInputAction.button_text = input_action.right.as_text_keycode()
	%RightInputAction.set_error_highlight(false)

func _read_event_or_null() -> InputEventKey:
	press_key_dialog.start_reading_input()
	var result = await press_key_dialog.input_read
	if result.canceled:
		return
	return result.event

func _on_button_up_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%UpInputAction.button_text = event.as_text_keycode()
		%UpInputAction.set_error_highlight(false)
		input_action.up = event
		set_action()

func _on_button_down_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%DownInputAction.button_text = event.as_text_keycode()
		%DownInputAction.set_error_highlight(false)
		input_action.down = event
		set_action()

func _on_button_left_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%LeftInputAction.button_text = event.as_text_keycode()
		%LeftInputAction.set_error_highlight(false)
		input_action.left = event
		set_action()

func _on_button_right_pressed() -> void:
	var event: InputEventKey = await _read_event_or_null()
	if event:
		%RightInputAction.button_text = event.as_text_keycode()
		%RightInputAction.set_error_highlight(false)
		input_action.right = event
		set_action()

func set_action():
	input_remapper_ui.set_action2d(action_name, input_action)

func on_detected_conflicting_inputs(input_action_list: Array[InputAction]) -> void:
	for conflicting_action: InputAction in input_action_list:
		if conflicting_action.contains_input_event(input_action.up):
			%UpInputAction.set_error_highlight(true)
		elif conflicting_action.contains_input_event(input_action.down):
			%DownInputAction.set_error_highlight(true)
		elif conflicting_action.contains_input_event(input_action.left):
			%LeftInputAction.set_error_highlight(true)
		elif conflicting_action.contains_input_event(input_action.right):
			%RightInputAction.set_error_highlight(true)
