extends Control

signal detected_conflicting_inputs(input_action_list: Array[InputAction])

@export var input_remapper_ui: InputRemapperUI
@export var action_name: StringName
@export var press_key_dialog: Control

func _ready() -> void:
	%ActionContainer.press_key_dialog = press_key_dialog
	%ActionContainer.action_name = action_name
	%ActionContainer.input_remapper_ui = input_remapper_ui
	detected_conflicting_inputs.connect(%ActionContainer.on_detected_conflicting_inputs)
	%JoystickContainer.action_name = action_name
	%JoystickContainer.input_remapper_ui = input_remapper_ui
	if input_remapper_ui:
		input_remapper_ui.detected_conflicting_inputs.connect(_on_detected_conflicting_inputs)

func update_ui(scheme: GatoControlScheme) -> void:
	for input_action in scheme.input_actions:
		if input_action.name != action_name:
			continue
		if input_action is JoystickInputAction2D:
			%JoystickToggle.use_joystick = true
			%JoystickToggle.update_ui()
			%JoystickContainer.update_ui(input_action)
		elif input_action is KeysInputAction2D:
			%JoystickToggle.use_joystick = false
			%JoystickToggle.update_ui()
			%ActionContainer.update_ui(input_action)

func _on_detected_conflicting_inputs(input_action_list: Array[InputAction]):
	detected_conflicting_inputs.emit(input_action_list)
