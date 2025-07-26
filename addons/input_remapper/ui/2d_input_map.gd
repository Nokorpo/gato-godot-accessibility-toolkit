extends Control

@export var action_name: StringName
@export var press_key_dialog: Control

func _ready() -> void:
	InputRemapper.control_scheme_changed.connect(update_ui)
	%ActionContainer.press_key_dialog = press_key_dialog
	update_ui(InputRemapper.get_current_scheme())

func update_ui(scheme: GatoControlScheme) -> void:
	for input_action in scheme.input_actions:
		if input_action.name != action_name:
			continue
		if input_action is JoystickInputAction2D:
			%JoystickSelector.update_ui(input_action)
			%InvertDirection.update_ui(input_action)
		elif input_action is KeysInputAction2D:
			%ActionContainer.update_ui(input_action)
