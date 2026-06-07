## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends HBoxContainer
## Lets the user choose whether to use a joystick or keyboard keys for an input action 2D

signal hud_zoom_level_changed(zoom_level: float)

@export var zoom_level_label: Label

@onready var joystick_cooldown: Timer = $JoystickCooldownTimer
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	zoom_level_label.text = "%d %%" % progress_bar.value

func increase_zoom() -> void:
	progress_bar.value += progress_bar.step
	zoom_level_label.text = "%d %%" % progress_bar.value
	hud_zoom_level_changed.emit(progress_bar.value)

func decrease_zoom() -> void:
	progress_bar.value -= progress_bar.step
	zoom_level_label.text = "%d %%" % progress_bar.value
	hud_zoom_level_changed.emit(progress_bar.value)

func _on_navigation_container_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_left"):
		joystick_cooldown.start()
		decrease_zoom()
	elif event.is_action("ui_right"):
		joystick_cooldown.start()
		increase_zoom()

func _on_lower_button_pressed() -> void:
	decrease_zoom()

func _on_increase_button_pressed() -> void:
	increase_zoom()
