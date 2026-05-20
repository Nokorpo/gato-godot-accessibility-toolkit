class_name InputRemapperUI
extends Control

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
	_control_scheme_selector.grab_focus.call_deferred()

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

func _has_unsaved_changes() -> bool:
	var index: int = _get_scheme_index(InputRemapper.get_current_scheme())
	var current_scheme := _schemes[index]
	return not current_scheme.equals(InputRemapper.get_stored_config()[index])

func save_changes() -> void:
	InputRemapper.control_schemes = _schemes
	var current_scheme := _schemes[_get_scheme_index(InputRemapper.get_current_scheme())]
	InputRemapper.apply_control_scheme(current_scheme)
	InputRemapper.save_changes()

func close() -> void:
	visible = false
	closed.emit()
