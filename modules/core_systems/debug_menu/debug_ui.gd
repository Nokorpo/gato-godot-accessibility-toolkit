## Debug UI for developer use
extends CanvasLayer

func _ready() -> void:
	%Version.set_text(_get_current_version())

func _process(_delta: float) -> void:
	%FPSCounterValue \
		.set_text("FPS: " + str(Engine.get_frames_per_second()))

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_B:
		toggle_visibility()

func _on_game_speed_slider_value_changed(value: float) -> void:
	Engine.time_scale = value
	%GameSpeedValue.text = "%1.2f" % value

func _on_toggle_bw_filter_pressed():
	$ColorRect.visible = !$ColorRect.visible

func toggle_visibility() -> void:
	visible = !visible
	if visible:
		$Panel.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$Panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _get_current_version() -> String:
	return ProjectSettings.get_setting("application/config/version")

func _on_performance_overlay_button_pressed() -> void:
	DebugMenu.style = wrapi(DebugMenu.style + 1, 0, DebugMenu.Style.MAX) as DebugMenu.Style
