class_name InputRemapperUI
extends Control

signal detected_conflicting_inputs(input_action_list: Array[InputAction])
signal closed

@export var _control_scheme_selector: Control
@export var _movement_input_map: Control
@export var _interactions_action_container: Control

@onready var pressed_key_dialog := $PressKeyDialog
@onready var close_without_saving_dialog := $CloseWithoutSavingDialog

var _schemes: Array[GatoControlScheme] = []
var _current_scheme: int = 0

func _ready() -> void:
	InputRemapper.control_scheme_changed.connect(populate_ui)
	_schemes = InputRemapper.control_schemes
	if _schemes.size() == 0:
		push_error("Error: tried to initialize GATO Input Mapper UI without any control scheme defined. Did you configure the control scheme file?")
		queue_free()
		return
	populate_ui(_schemes[InputRemapper.current_control_scheme_index])
	grab_focus.call_deferred()

func grab_focus(hide_focus: bool = false) -> void:
	_control_scheme_selector.grab_focus.call_deferred(hide_focus)
	#$PanelContainer/MarginContainer/ScrollContainer.scroll_vertical = 0

func _is_back_input(event: InputEvent) -> bool:
	return (
		event is InputEventKey and event.keycode == KEY_ESCAPE \
		or event is InputEventJoypadButton and event.button_index == JOY_BUTTON_B
	) and event.is_pressed()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if _is_back_input(event) and _has_unsaved_changes():
		close_without_saving_dialog.show()
		get_viewport().set_input_as_handled()
	# else: don't set input as handled so the game can handle it

func _get_scheme_index(scheme: GatoControlScheme) -> int:
	return _schemes.find_custom(
		func (it: GatoControlScheme): return it.name == scheme.name
	)

func populate_ui(scheme: GatoControlScheme) -> void:
	if scheme == null:
		push_error("Tried to initialize Input Remapper with empty scheme")
		return
	var index := _get_scheme_index(scheme)
	var current_scheme := InputRemapper.get_current_scheme()
	_schemes = InputRemapper.control_schemes
	_control_scheme_selector._update_ui(_schemes, index)
	_movement_input_map.update_ui(current_scheme)
	var inputs: Array[InputActionButton] = []
	for input in current_scheme.input_actions:
		if input is InputActionButton:
			inputs.append(input)
	_interactions_action_container.update_ui(inputs)

func set_action(action_name: StringName, event: InputEvent) -> void:
	var current_scheme := _schemes[_get_scheme_index(InputRemapper.get_current_scheme())]
	var action_index := current_scheme.input_actions.find_custom(
		func(it): return it.name == action_name
	)
	current_scheme.input_actions[action_index].input = event

func set_action2d(action_name: StringName, new_input_action2d: InputAction) -> void:
	if new_input_action2d is not KeysInputAction2D and new_input_action2d is not JoystickInputAction2D:
		push_error("Error: tried to set action \"%s\" with an InputAction object that isn't an Input Action 2D." % action_name)
		return
	var current_scheme := _schemes[_get_scheme_index(InputRemapper.get_current_scheme())]
	var action_index := current_scheme.input_actions.find_custom(
		func(it): return it.name == action_name
	)
	current_scheme.input_actions[action_index] = new_input_action2d

func _check_for_conflicting_input(control_scheme: GatoControlScheme) -> bool:
	var actions: Array[InputAction] = control_scheme.input_actions
	var actions_with_duplicated_input := _find_duplicates(actions)
	if actions_with_duplicated_input.size() > 0:
		detected_conflicting_inputs.emit(actions_with_duplicated_input)
		return true
	return false

func _find_duplicates(actions: Array[InputAction]) -> Array[InputAction]:
	# FIXME this is a hack, we should make a proper function for this,
	# but it's quick to implement it this way for now.
	var actions_with_duplicated_input: Array[InputAction] = []
	for action_a: InputAction in actions:
		var current_action := action_a.duplicate(true)
		current_action.name = "test"
		for action_b: InputAction in actions:
			var other_action := action_b.duplicate(true)
			other_action.name = "test"
			if action_a == action_b:
				continue
			if current_action.equals(other_action):
				actions_with_duplicated_input.append(action_a)
			if action_b is KeysInputAction2D:
				if _find_duplicates_in_keysinputaction2d(action_a, action_b):
					actions_with_duplicated_input.append(action_a)
	return actions_with_duplicated_input

# FIXME this should be a method in InputActions that lets you check for conflicts, not this
func _find_duplicates_in_keysinputaction2d(action_a: InputAction, action_b) -> bool:
	return action_a.contains_input_event(action_b.up)\
		or action_a.contains_input_event(action_b.down)\
		or action_a.contains_input_event(action_b.left)\
		or action_a.contains_input_event(action_b.right)

func _has_unsaved_changes() -> bool:
	var index: int = _get_scheme_index(InputRemapper.get_current_scheme())
	var current_scheme := _schemes[index]
	return not current_scheme.equals(InputRemapper.get_stored_config()[index])

func save_changes() -> void:
	InputRemapper.control_schemes = _schemes
	var current_scheme := _schemes[_get_scheme_index(InputRemapper.get_current_scheme())]
	if _check_for_conflicting_input(current_scheme):
		$ErrorDialog.show()
		print("Found conflicting input. Skipping save.")
		return
	InputRemapper.apply_control_scheme(current_scheme)
	InputRemapper.save_changes()

func close() -> void:
	visible = false
	closed.emit()
