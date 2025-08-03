extends Control

@export var input_remapper_ui: InputRemapperUI
@export var action_name: StringName
@export var press_key_dialog: Control

func _ready() -> void:
	%ActionContainer.press_key_dialog = press_key_dialog
	%ActionContainer.action_name = action_name
	%ActionContainer.input_remapper_ui = input_remapper_ui
	%JoystickSelector.action_name = action_name
	%JoystickSelector.input_remapper_ui = input_remapper_ui
	%InvertDirection.action_name = action_name
	%InvertDirection.input_remapper_ui = input_remapper_ui

func update_ui(scheme: GatoControlScheme) -> void:
	for input_action in scheme.input_actions:
		if input_action.name != action_name:
			continue
		if input_action is JoystickInputAction2D:
			%JoystickSelector.update_ui(input_action)
			%InvertDirection.update_ui(input_action)
		elif input_action is KeysInputAction2D:
			%ActionContainer.update_ui(input_action)
