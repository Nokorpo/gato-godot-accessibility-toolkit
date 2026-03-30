extends Container

@onready var current_scheme_label: Label = $RowNavigationContainer/HBoxContainer/HBoxContainer/CurrentScheme
@onready var next_scheme_label: Label = $RowNavigationContainer/HBoxContainer/NextScheme
@onready var second_next_scheme_label: Label = $RowNavigationContainer/HBoxContainer/NextScheme2
@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

func _update_ui(scheme_list: Array[GatoControlScheme], current_scheme: int) -> void:
	current_scheme_label.text = scheme_list[current_scheme].name
	next_scheme_label.text = scheme_list[(current_scheme + 1) % scheme_list.size()].name
	second_next_scheme_label.text = scheme_list[(current_scheme + 2) % scheme_list.size()].name

func _on_row_navigation_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_right"):
		joystick_cooldown.start()
		_load_next_scheme()
	elif event.is_action("ui_left"):
		joystick_cooldown.start()
		_load_last_scheme()

func _load_next_scheme() -> void:
	InputRemapper.load_next_scheme()

func _load_last_scheme() -> void:
	InputRemapper.load_previous_scheme()

func reset_config() -> void:
	InputRemapper.reset_changes()
