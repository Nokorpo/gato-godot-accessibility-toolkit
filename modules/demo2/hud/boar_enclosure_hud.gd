class_name EnclosureHUD
extends CanvasLayer

enum HUD { UPPER_LEFT, BOTTOM_CENTER, BOTTOM_LEFT }

@onready var _hud_nodes: Dictionary = {
	HUD.UPPER_LEFT: $Control/UpperLeft,
	HUD.BOTTOM_CENTER: $Control/BottomCenter,
	HUD.BOTTOM_LEFT: $Control/BottomLeft
}

var _selected_hud: HUD = HUD.UPPER_LEFT

func _ready() -> void:
	for hud: Control in _hud_nodes.values():
		hud.hide()
	_hud_nodes[_selected_hud].show()

func show_enclosure_indicator(assigned_enclosure: Enclosure.EnclosureType) -> void:
	$Control.show()
	for hud: Control in _hud_nodes.values():
		hud.set_enclosure(assigned_enclosure)

func hide_enclosure_indicator() -> void:
	$Control.hide()

func change_hud(hud: HUD) -> void:
	_hud_nodes[_selected_hud].hide()
	_selected_hud = hud
	_hud_nodes[_selected_hud].show()

func change_zoom(zoom_level: float) -> void:
	for hud: Control in _hud_nodes.values():
		hud.set_zoom_level(zoom_level)
