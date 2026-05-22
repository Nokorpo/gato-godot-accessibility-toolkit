extends VBoxContainer

signal detected_conflicting_inputs(input_action_list: Array[InputAction])

@export var input_remapper_ui: InputRemapperUI
@export var press_key_dialog: Control

var input_actions: Array[InputActionButton] = []
var use_right_joystick := false
var input_action_nodes: Array[Control] = []

var row_scene: PackedScene = load("res://addons/input_remapper/ui/row_navigation_container.tscn")
var input_action_scene: PackedScene = load("res://addons/input_remapper/ui/input_action.tscn")

func _ready() -> void:
	if input_remapper_ui:
		input_remapper_ui.detected_conflicting_inputs.connect(_on_detected_conflicting_inputs)

func update_ui(_input_actions: Array[InputActionButton]) -> void:
	input_actions = _input_actions
	input_action_nodes = []
	for child in get_children():
		child.queue_free()

	for input_action in input_actions:
		var input_action_ui = input_action_scene.instantiate()
		input_action_ui.set_label(input_action.name)
		input_action_ui.set_button(input_action.input.as_text_keycode())
		input_action_ui.pressed.connect(_on_button_pressed.bind(input_action.name))
		input_action_nodes.append(input_action_ui)

		var row_ui = row_scene.instantiate()
		row_ui.add_child(input_action_ui)
		row_ui.pressed.connect(_on_button_pressed.bind(input_action.name))

		add_child(row_ui)

func get_button_for_action(action_name: String) -> Button:
	return _get_button_for_action_recursive(action_name, self)

func _get_button_for_action_recursive(action_name: String, node: Control) -> Button:
	if node is Label and node.text == action_name:
		for child in node.get_parent().get_children():
			if child is Button:
				return child
	elif node.get_child_count() > 0:
		for child in node.get_children():
			var button_or_null := _get_button_for_action_recursive(action_name, child)
			if button_or_null:
				return button_or_null
	return null

func _read_event_or_null() -> InputEventKey:
	press_key_dialog.start_reading_input()
	var result = await press_key_dialog.input_read
	if result.canceled:
		return

	return result.event

func _on_button_pressed(action_name: String) -> void:

	var event: InputEventKey = await _read_event_or_null()
	if not event:
		return

	var button := get_button_for_action(action_name)
	if button == null:
		return
	button.text = event.as_text_keycode()
	input_remapper_ui.set_action(action_name, event)

	var action_index: int = _find_input_action_index(action_name)
	input_action_nodes[action_index].set_error_highlight(false)

func _find_input_action_index(action_name: StringName) -> int:
	for i in range(input_actions.size()):
		if input_actions[i].name == action_name:
			return i
	push_error("The action name '%s' was not found in the current interaction action list." % action_name)
	return -1

func _on_detected_conflicting_inputs(input_action_list: Array[InputAction]):
	detected_conflicting_inputs.emit(input_action_list)
	for conflict_action: InputAction in input_action_list:
		for input_action in input_actions:
			if input_action.equals(conflict_action):
				var index = _find_input_action_index(conflict_action.name)
				input_action_nodes[index].set_error_highlight(true)
