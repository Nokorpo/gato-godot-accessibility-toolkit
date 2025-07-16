extends StaticBody3D

signal button_activated
signal button_deactivated
signal button_toggled(toggle: bool)

@export var can_detect_light_weights: bool = true

var items: int = 0
var active: bool = false

func _on_activation_area_body_entered(body: Node3D) -> void:
	if body is StaticBody3D:
		return
	if body.is_in_group("heavy_weight") or (can_detect_light_weights and body.is_in_group("light_weight")):
		items += 1
		if not active:
			active = true
			button_activated.emit()
			button_toggled.emit(active)

func _on_activation_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("heavy_weight") or (can_detect_light_weights and body.is_in_group("light_weight")):
		items -= 1
		if active and items == 0:
			active = false
		button_deactivated.emit()
		button_toggled.emit(active)
