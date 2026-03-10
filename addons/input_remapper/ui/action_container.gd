extends VBoxContainer

@export var input_remapper_ui: InputRemapperUI
@export var press_key_dialog: Control

var input_actions: Array[InputActionButton] = []
var use_right_joystick := false

var row_scene: PackedScene = load("res://addons/input_remapper/ui/row_navigation_container.tscn")
var input_action_scene: PackedScene = load("res://addons/input_remapper/ui/input_action.tscn")

func update_ui(_input_actions: Array[InputActionButton]) -> void:
	input_actions = _input_actions
	for child in get_children():
		child.queue_free()

	for input_action in input_actions:
		var input_action_ui = input_action_scene.instantiate()
		input_action_ui.set_label(input_action.name)
		input_action_ui.set_button(input_action.input.as_text_keycode())
		input_action_ui.pressed.connect(_on_button_pressed.bind(input_action.name))

		var row_ui = row_scene.instantiate()
		row_ui.add_child(input_action_ui)

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
			return _get_button_for_action_recursive(action_name, child)
	return null

func _on_button_pressed(action_name: String) -> void:
	press_key_dialog.start_reading_input()
	var event = await press_key_dialog.input_read
	var button := get_button_for_action(action_name)
	if button == null:
			return
	button.text = event.as_text_keycode()
	input_remapper_ui.set_action(action_name, event)
