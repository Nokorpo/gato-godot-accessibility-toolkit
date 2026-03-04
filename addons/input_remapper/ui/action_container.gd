extends GridContainer

@export var input_remapper_ui: InputRemapperUI
@export var press_key_dialog: Control

var input_actions: Array[InputActionButton] = []
var use_right_joystick := false

func update_ui(_input_actions: Array[InputActionButton]) -> void:
	input_actions = _input_actions
	for child in get_children():
		child.queue_free()

	for input_action in input_actions:
		var label := Label.new()
		label.text = input_action.name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var button := Button.new()
		button.text = input_action.input.as_text_keycode()
		button.focus_mode = Control.FOCUS_NONE
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_button_pressed.bind(input_action.name))
		add_child(label)
		add_child(button)

func get_button_for_action(action_name: String) -> Button:
	var i: int = 0
	while i < get_child_count():
		var child: Node = get_child(i)
		if child is Label and child.text == action_name:
			break
		i +=1
	if i >= get_child_count():
		return
	return get_child(i+1) as Button

func _on_button_pressed(action_name: String) -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	var button := get_button_for_action(action_name)
	if button == null:
			return
	button.text = event.as_text_keycode()
	input_remapper_ui.set_action(action_name, event)
