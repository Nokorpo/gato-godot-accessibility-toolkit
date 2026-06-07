extends HBoxContainer

signal hud_position_changed(position: EnclosureHUD.HUD)

@onready var joystick_cooldown: Timer = $JoystickCooldownTimer

var _hud_position_to_text_map: Dictionary = {
	EnclosureHUD.HUD.UPPER_LEFT: "Superior izquierda",
	EnclosureHUD.HUD.BOTTOM_CENTER: "Inferior centro",
	EnclosureHUD.HUD.BOTTOM_LEFT: "Inferior izquierda"
}
var _current_selection: EnclosureHUD.HUD = EnclosureHUD.HUD.UPPER_LEFT

func _ready() -> void:
	_update_text()

func _update_text() -> void:
	$Label.text = _hud_position_to_text_map[_current_selection]

func _on_navigation_container_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey and not event.is_pressed():
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) <= .95 or joystick_cooldown.time_left >= 0.01:
			return

	if event.is_action("ui_left"):
		joystick_cooldown.start()
		_on_left_button_pressed()
	elif event.is_action("ui_right"):
		joystick_cooldown.start()
		_on_right_button_pressed()

func _on_left_button_pressed() -> void:
	var index: int = _current_selection - 1
	_current_selection = (posmod(index, EnclosureHUD.HUD.size())) as EnclosureHUD.HUD
	_update_text()
	hud_position_changed.emit(_current_selection)

func _on_right_button_pressed() -> void:
	var index: int = _current_selection + 1
	_current_selection = (posmod(index, EnclosureHUD.HUD.size())) as EnclosureHUD.HUD
	_update_text()
	hud_position_changed.emit(_current_selection)
