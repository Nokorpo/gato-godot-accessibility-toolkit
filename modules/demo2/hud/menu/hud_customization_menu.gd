extends CanvasLayer

signal hud_position_changed(position: EnclosureHUD.HUD)
signal hud_zoom_level_changed(zoom_level: float)

@export var position_control: RowNavigationContainer

func get_button_text() -> String:
	return "Personalización HUD"

func grab_focus() -> void:
	position_control.grab_focus()

func _on_hud_position_changed(position: EnclosureHUD.HUD) -> void:
	hud_position_changed.emit(position)

func _on_hud_zoom_level_changed(zoom_level: float) -> void:
	hud_zoom_level_changed.emit(zoom_level)
