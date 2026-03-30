extends HBoxContainer
## Lets the user choose whether to use a joystick or keyboard keys for an input action 2D

@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

var use_joystick := false

func _on_button_pressed() -> void:
	use_joystick = !use_joystick
	update_ui()
	# This is done outside the "update_ui()" method to avoid an initialization
	# issue where the keymap is unset on the first frame due to a default object
	if use_joystick:
		%JoystickContainer.set_action()
	else:
		%ActionContainer.set_action()

func update_ui() ->void :
	if use_joystick:
		$Label.text = "Joystick"
		get_parent().focus_neighbor_bottom = ^"../JoystickContainer/UpRowNavigationContainer2"
		%ActionContainer.hide()
		%JoystickContainer.show()

	else:
		$Label.text = "Keyboard"
		get_parent().focus_neighbor_bottom = ^"../ActionContainer/UpRowNavigationContainer"
		%ActionContainer.show()
		%JoystickContainer.hide()

func _on_navigation_container_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_left") or event.is_action("ui_right"):
		joystick_cooldown.start()
		_on_button_pressed()
