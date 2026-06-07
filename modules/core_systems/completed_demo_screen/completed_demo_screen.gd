## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

const DEMO_SECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

## A reference to the parent scene, removed when the "Quit" option is selected.
@onready var parent_scene: Node = get_parent()

@export var _first_selected_button: Control

func show_screen() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	_first_selected_button.grab_focus()
	visible = true
	$BackgroundBlur.show_blur()
	%AnimationPlayer.play("demo_completed")

func resume_demo() -> void:
	visible = false
	$BackgroundBlur.hide_blur()
	get_tree().paused = false

func quit_and_go_to_menu() -> void:
	get_tree().paused = false
	var _scene_loader: SceneLoader = SceneLoader.create_scene_loader(parent_scene, DEMO_SECTOR_PATH)

func show_quit_confirmation_screen() -> void:
	%QuitConfirmation.visible = true

func _on_quit_confirmation_visibility_changed() -> void:
	if not %QuitConfirmation.visible:
		_first_selected_button.grab_focus()
