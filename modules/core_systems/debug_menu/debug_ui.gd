## Debug UI for developer use
extends CanvasLayer

@onready var panel: Control = $Panel

func _ready() -> void:
	%Version.set_text(_get_current_version())

func _process(_delta: float) -> void:
	%FPSCounterValue \
		.set_text(str(Engine.get_frames_per_second()))

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_B:
		toggle_visibility()

func _on_game_speed_slider_value_changed(value: float) -> void:
	Engine.time_scale = value
	%GameSpeedValue.text = "%1.2f" % value

func toggle_visibility() -> void:
	panel.visible = !panel.visible
	if panel.visible:
		panel.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _get_current_version() -> String:
	return ProjectSettings.get_setting("application/config/version")

func _on_performance_overlay_button_pressed() -> void:
	DebugMenu.style = wrapi(DebugMenu.style + 1, 0, DebugMenu.Style.MAX) as DebugMenu.Style

func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		$ColorRect.visible = false
	else:
		$ColorRect.visible = true
		$ColorRect.material.set_shader_parameter("type", index)
