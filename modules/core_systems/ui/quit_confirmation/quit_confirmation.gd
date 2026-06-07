## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

@export var _confirm_button: Control

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		$BackgroundBlur.show_blur()
		_confirm_button.grab_focus()

func exit_game() -> void:
	get_tree().quit()

func hide_confirmation_screen() -> void:
	await $BackgroundBlur.hide_blur().finished
	visible = false
