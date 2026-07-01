## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A selector that lets the user choose whether to use a joystick (JoystickInputAction2D)
## or keys/controller buttons (KeysInputAction2D) for an input action 2D.
extends HBoxContainer

## Emitted when the user changes from Joystick to Keys or viceversa.
signal toggle_changed(use_joystick: bool)

## The sound played when a change is made on the selection.
@export var accept_sound: AudioStreamPlayer

## Timer that limits the speed of this selector when using a joystick. This is used
## because otherwise Godot logs dozens of joystick motion events every second and it's
## impossible to select the value you want.
@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

## Whether the InputAction will use JoystickInputAction2D (true) or KeysInputAction2D (false).
var use_joystick := false

func _on_button_pressed() -> void:
	use_joystick = !use_joystick
	accept_sound.play()
	update_ui()
	# This is done outside the "update_ui()" method to avoid an initialization
	# issue where the keymap is unset on the first frame due to a default object
	if use_joystick:
		%JoystickContainer.set_action()
	else:
		%ActionContainer.set_action()

## Reacts to the `GatoInputRemapper.control_scheme_changed` signal to populate the UI with the
## loaded control scheme and propagates it down to its descendants so they can do the same.
func update_ui() ->void :
	toggle_changed.emit(use_joystick)
	if use_joystick:
		$Label.text = "Joystick"
		get_parent().focus_neighbor_bottom = ^"../JoystickContainer/UpRowNavigationContainer2"
		%ActionContainer.hide()
		%JoystickContainer.show()

	else:
		$Label.text = "keyboard"
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
