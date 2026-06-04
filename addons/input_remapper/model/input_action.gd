## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name InputAction
extends InputConfig

@export var category: StringName

func _init(_name: StringName, _category: StringName = "") -> void:
	super(_name)
	category = _category

func apply_config() -> void:
	push_error("Error: method \"apply_config()\" not implemented")
	return

func get_category() -> StringName:
	return category

func equals(other_action: InputAction) -> bool:
	push_error("Error: method \"equals()\" not implemented")
	return false

func contains_input_event(input_event: InputEvent) -> bool:
	push_error("Error: method \"equals()\" not implemented")
	return false

func get_as_dict() -> Dictionary:
	push_error("Error: method \"get_as_dict()\" not implemented")
	return {}

static func new_from_dict(dict: Dictionary) -> InputAction:
	push_error("Error: method \"new_from_dict()\" not implemented")
	return null
