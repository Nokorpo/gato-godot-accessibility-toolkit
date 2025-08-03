extends CanvasLayer

const DEMO_SECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

## A reference to the parent scene, removed when the "Quit" option is selected.
@onready var parent_scene: Node = get_parent()
## Waits for some time after the menu button is pressed before opening/closing it again.
@onready var cooldown_timer: Timer = $OpenMenuCooldown

var _settings_menu: Node

func _input(event: InputEvent) -> void:
	if event.is_action("game_menu") and event.is_pressed():
		_toggle_visibility()

func _toggle_visibility() -> void:
	visible = !visible
	get_tree().paused = visible
	if _settings_menu != null:
		_settings_menu.queue_free()

func open_settings() -> void:
	## TODO open setting
	print("this would open the settings, but not yet")
	var coso: PackedScene = load("res://addons/input_remapper/ui/input_remapper_ui.tscn")
	_settings_menu = coso.instantiate()
	add_child(_settings_menu)

func quit_and_go_to_menu() -> void:
	get_tree().paused = false
	var coso: SceneLoader = SceneLoader.create_scene_loader(parent_scene, DEMO_SECTOR_PATH)
