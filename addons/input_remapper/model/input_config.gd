class_name InputConfig
extends Resource

@export var name: StringName

func _init(_name: StringName) -> void:
	name = _name

func apply_config() -> void:
	printerr("Error: method \"apply_config()\" not implemented")
	return

func get_as_dict() -> Dictionary:
	printerr("Error: method \"get_as_dict()\" not implemented")
	return {}

static func new_from_dict(dict: Dictionary) -> InputConfig:
	printerr("Error: method \"new_from_dict()\" not implemented")
	return null
