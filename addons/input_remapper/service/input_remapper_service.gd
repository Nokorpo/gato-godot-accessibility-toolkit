extends RefCounted

# Services
var storage_service

var current_control_scheme_index: int = 0
var control_schemes: Array = []

func _init() -> void:
	storage_service = load("res://addons/input_remapper/service/storage_service.gd")
	control_schemes = storage_service.load_input_config()

func load_next_scheme() -> void:
	current_control_scheme_index += 1 % control_schemes.size()
	apply_control_scheme(control_schemes[current_control_scheme_index])

func load_previous_scheme() -> void:
	current_control_scheme_index -= 1 % control_schemes.size()
	apply_control_scheme(control_schemes[current_control_scheme_index])

func apply_control_scheme(control_scheme: GatoControlScheme) -> void:
	for action in control_scheme.input_actions:
		if not action.has_method("apply_config"):
			printerr("Tried to apply a control scheme with an object without an \"apply_config()\" method.")
			continue
		action.apply_config()

func reset_control_scheme() -> void:
	pass
