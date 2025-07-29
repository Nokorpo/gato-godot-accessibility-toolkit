extends CanvasLayer

const DEMO_SECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

## A reference to the parent scene, removed when the "Quit" option is selected.
@onready var parent_scene: Node = get_parent()
## Waits for some time after the menu button is pressed before opening/closing it again.
@onready var cooldown_timer: Timer = $OpenMenuCooldown

func _input(event: InputEvent) -> void:
	if event.is_action("game_menu") and event.is_pressed():
		_toggle_visibility()

func _toggle_visibility() -> void:
	visible = !visible
	get_tree().paused = visible

func quit_and_go_to_menu() -> void:
	get_tree().paused = false
	var coso: SceneLoader = SceneLoader.create_scene_loader(parent_scene, DEMO_SECTOR_PATH)
