## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This autoload is the main point of interaction from your code to the addon. It let's you do
## things like get the current control scheme, change to a different control scheme, load/save the
## configuration and react to the controls updating or being saved from a central point.
##
## You can use the methods and signals in this autoload to programatically create a UI for the input
## remapper in your game. You have an example of that in `res://addons/gato_input_remapper/ui/input_remapper_ui.tscn`.
@tool
extends Node

## Emitted when the current control schemes configuratin is saved to the `input.data` file.
signal control_scheme_saved_to_file
## Emitted when the current control scheme changes to a different one. The parameter is the newly
## loaded control scheme.
signal control_scheme_changed(new_scheme: GatoControlScheme)

# Services
## Reference to the storage service that handles config file saving and loading.
## See `res://addons/gato_input_remapper/service/storage_service.gd`
var storage_service
## List of currently loaded control schemes. The current control scheme can be accessed by using the
## `current_control_scheme_index` property.
var control_schemes: Array[GatoControlScheme] = []
## Index of the currently selected control scheme. This index is based on the `control_schemes`
## property. So, if the first scheme from the `control_schemes` list is loaded, it will be `control_schemes[0]`.
var current_control_scheme_index: int = 0

func _init(_storage_service: Variant = null) -> void:
	if _storage_service == null:
		storage_service = load("res://addons/gato_input_remapper/service/storage_service.gd").new()
	else:
		storage_service = _storage_service

	control_schemes = storage_service.load_input_config_from_file()

## Returns the currently selected control scheme.
func get_current_scheme() -> GatoControlScheme:
	return control_schemes[current_control_scheme_index]

## Loads and applies the next control scheme in the `control_schemes` list. If it reaches the end of
## the list, it loops back to the initial element.
func load_next_scheme() -> void:
	current_control_scheme_index = (current_control_scheme_index + 1) % control_schemes.size()
	apply_control_scheme(control_schemes[current_control_scheme_index])
	control_scheme_changed.emit(control_schemes[current_control_scheme_index])

## Loads and applies the previous control scheme in the `control_schemes` list. If it reaches the
## beginning of the list, it loops back to the final element.
func load_previous_scheme() -> void:
	current_control_scheme_index = (current_control_scheme_index - 1) % control_schemes.size()
	apply_control_scheme(control_schemes[current_control_scheme_index])
	control_scheme_changed.emit(control_schemes[current_control_scheme_index])

## Applies the configuration defined in the parameter control scheme.
func apply_control_scheme(control_scheme: GatoControlScheme) -> void:
	for action in control_scheme.input_actions:
		if not action.has_method("apply_config"):
			push_error("Tried to apply a control scheme with an object without an \"apply_config()\" method.")
			continue
		action.apply_config()

## Saves the changes on the control schemes list in memory to the `input.data` file.
func save_changes() -> void:
	storage_service.store_input_config(control_schemes)
	control_scheme_saved_to_file.emit()

## Loads the control scheme list from the `input.data` file.
func get_stored_config() -> Array[GatoControlScheme]:
	return storage_service.load_input_config_from_file()

## Discards the changes to the control schemes in memory and reverts them back to the version in the
## `input.data` file.
func reset_changes() -> void:
	control_schemes = storage_service.load_input_config_from_file()
	apply_control_scheme(control_schemes[current_control_scheme_index])
	control_scheme_changed.emit(control_schemes[current_control_scheme_index])
