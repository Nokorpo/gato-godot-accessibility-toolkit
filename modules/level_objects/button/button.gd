## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StaticBody3D

signal button_activated
signal button_deactivated
signal button_toggled(toggle: bool)

@export var can_detect_light_weights: bool = true

var items: int = 0
var active: bool = false
var item_list: Array = []

func _on_activation_area_body_entered(body: Node3D) -> void:
	if body is StaticBody3D:
		return
	if body.is_in_group("heavy_weight") or (can_detect_light_weights and body.is_in_group("light_weight")):
		items += 1
		item_list.append(body)
		if not active:
			active = true
			$AnimationPlayer.play("activate")
			$ClickSound.play()
			button_activated.emit()
			button_toggled.emit(active)

func _on_activation_area_body_exited(body: Node3D) -> void:
	if body is StaticBody3D:
		return
	if body.is_in_group("heavy_weight") or (can_detect_light_weights and body.is_in_group("light_weight")):
		items -= 1
		item_list.erase(body)
		if active and items == 0:
			active = false
			$AnimationPlayer.play("deactivate")
			$ClickSound.play()
		button_deactivated.emit()
		button_toggled.emit(active)
