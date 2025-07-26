extends Node

# Services
var storage_service

var current_control_scheme_index: int = 0
var control_schemes: Array[GatoControlScheme] = []

func _init(_storage_service: Variant = null) -> void:
	if _storage_service == null:
		storage_service = load("res://addons/input_remapper/service/storage_service.gd").new()
	else:
		storage_service = _storage_service

	control_schemes = storage_service.load_input_config_from_file()

func get_current_scheme() -> GatoControlScheme:
	return control_schemes[current_control_scheme_index]

func load_next_scheme() -> void:
	current_control_scheme_index += 1 % control_schemes.size()
	apply_control_scheme(control_schemes[current_control_scheme_index])

func load_previous_scheme() -> void:
	current_control_scheme_index -= 1 % control_schemes.size()
	apply_control_scheme(control_schemes[current_control_scheme_index])

func apply_control_scheme(control_scheme: GatoControlScheme) -> void:
	for action in control_scheme.input_actions:
		if not action.has_method("apply_config"):
			push_error("Tried to apply a control scheme with an object without an \"apply_config()\" method.")
			continue
		action.apply_config()

func save_changes() -> void:
	storage_service.store_input_config(control_schemes)

func reset_changes() -> void:
	control_schemes = storage_service.load_input_config_from_file()
