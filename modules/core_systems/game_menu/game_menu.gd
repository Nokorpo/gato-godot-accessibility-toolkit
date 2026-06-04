## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

const DEMO_SECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

signal closed

## A reference to the parent scene, removed when the "Quit" option is selected.
@onready var parent_scene: Node = get_parent()
## Waits for some time after the menu button is pressed before opening/closing it again.
@onready var cooldown_timer: Timer = $OpenMenuCooldown

var _settings_menu: Node

func _is_back_input(event: InputEvent) -> bool:
	return (
		event is InputEventKey and event.keycode == KEY_ESCAPE \
		or event is InputEventJoypadButton and event.button_index == JOY_BUTTON_B
	) and event.is_pressed()

func _unhandled_input(event: InputEvent) -> void:
	if _settings_menu != null and _is_back_input(event):
		_settings_menu.queue_free()
		_settings_menu = null
		get_viewport().set_input_as_handled()
		return

	if event.is_action("game_menu") and event.is_pressed():
		_toggle_visibility()
		get_viewport().set_input_as_handled()

func _toggle_visibility() -> void:
	if visible:
		await $BackgroundBlur.hide_blur().finished
		get_tree().paused = false
		visible = false
		closed.emit()
	else:
		visible = true
		get_tree().paused = true
		$Control/MarginContainer/PanelContainer/VBoxContainer/SettingsButton.grab_focus()
		await $BackgroundBlur.show_blur().finished

	if _settings_menu != null:
		_settings_menu.queue_free()
		_settings_menu = null

func open_settings() -> void:
	var settings_scene: PackedScene = load("res://addons/input_remapper/ui/input_remapper_ui.tscn")
	_settings_menu = settings_scene.instantiate()
	$CanvasLayer.add_child(_settings_menu)

func quit_and_go_to_menu() -> void:
	get_tree().paused = false
	var _scene_loader: SceneLoader = SceneLoader.create_scene_loader(parent_scene, DEMO_SECTOR_PATH)
