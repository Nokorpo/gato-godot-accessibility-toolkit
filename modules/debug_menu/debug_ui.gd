## Debug UI for developer use
extends CanvasLayer

func _ready() -> void:
	$Panel/MarginContainer/HBoxContainer/HBoxContainer/Version \
		.set_text("VERSION: " + _get_current_version())
	$"../Version".set_text(_get_current_version())

func _process(_delta: float) -> void:
	%FPSCounter \
		.set_text("FPS: " + str(Engine.get_frames_per_second()))

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_B:
		toggle_visibility()

func _on_game_speed_slider_value_changed(value: float) -> void:
	Engine.time_scale = value
	$Panel/MarginContainer/HBoxContainer/GameSpeed/Value.text = "%1.2f" % value

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
