extends VBoxContainer

var input_remapper_ui: InputRemapperUI
var action_name: StringName
var input_action: JoystickInputAction2D

func _ready() -> void:
	%JoystickSelector.joystick_container = self
	%InvertDirection.joystick_container = self
	%JoystickSelector.value_changed.connect(_set_use_right_joystick)
	%InvertDirection.value_changed.connect(_set_invert)
	input_action = JoystickInputAction2D.new()

func _set_use_right_joystick(use_right_joystick: bool) -> void:
	%JoystickSelector.set_stick(use_right_joystick)
	input_action.use_right_joystick = use_right_joystick
	set_action()

func _set_invert(invert_joystick: bool) -> void:
	%InvertDirection.button_pressed = invert_joystick
	input_action.invert_joystick = invert_joystick
	set_action()

func update_ui(_input_action: JoystickInputAction2D) -> void:
	input_action = _input_action
	action_name = _input_action.name
	_set_use_right_joystick(input_action.use_right_joystick)
	_set_invert(input_action.invert_joystick)

func set_action() -> void:
	input_remapper_ui.set_action2d(action_name, input_action)
