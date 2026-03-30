extends HBoxContainer

signal value_changed(new_value: bool)

@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

var joystick_container
var use_right_joystick := false

func _on_row_navigation_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_left") or event.is_action("ui_right"):
		joystick_cooldown.start()
		toggle()

func toggle() -> void:
	use_right_joystick = !use_right_joystick
	set_stick_text(use_right_joystick)
	value_changed.emit(use_right_joystick)

func _on_button_pressed() -> void:
	toggle()

func set_stick_text(use_right: bool) -> void:
	if use_right:
		$Label.text = "Right"
	else:
		$Label.text = "Left"
