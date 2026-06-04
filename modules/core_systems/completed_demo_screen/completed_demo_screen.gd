## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

const DEMO_SECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

## A reference to the parent scene, removed when the "Quit" option is selected.
@onready var parent_scene: Node = get_parent()

func show_screen() -> void:
	await get_tree().create_timer(0.5).timeout
	visible = true
	$BackgroundBlur.show_blur()
	%AnimationPlayer.play("demo_completed")
	get_tree().paused = true

func resume_demo() -> void:
	visible = false
	$BackgroundBlur.hide_blur()
	get_tree().paused = false

func quit_and_go_to_menu() -> void:
	get_tree().paused = false
	var _scene_loader: SceneLoader = SceneLoader.create_scene_loader(parent_scene, DEMO_SECTOR_PATH)
	
func show_quit_confirmation_screen() -> void:
	%QuitConfirmation.visible = true
