## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is an abstraction of a generic input -> action configuration. It declares variables
## and methods that will be used later to de/serialize and apply this configuration, but leaves the
## implementation to the implementing sub-classes.
@tool
class_name InputAction
extends InputConfig

## InputActions can be put into categories, groups used to choose what o show first and so related
## actions are grouped together in the UI. This is just a String. InputActions that share the same
## category tend to be shown together, but there is no hard rule making it mandatory policy.
@export var category: StringName

func _init(_name: StringName, _category: StringName = "") -> void:
	super(_name)
	category = _category

## If you want to use an InputAction, this is the method to call. This method tells the InputAction
## to call Godot's Input API to configure itself there. For concrete actions, this means creating an
## action on the InputMap and assigning the input to it, for schemes or group of actions this means
## applying each InputAction individually.
func apply_config() -> void:
	push_error("Error: method \"apply_config()\" not implemented")
	return

## Returns the InputAction's category. Categories are just groups used to choose what o show first
## and so related actions are grouped together in the UI.
func get_category() -> StringName:
	return category

## Checks if the passed InputAction has the same value as the current instance. Returns true if so,
## false otherwise.
func equals(other_action: InputAction) -> bool:
	push_error("Error: method \"equals()\" not implemented")
	return false

## Checks if the InputAction uses the parameter InputEvent in any way.
##
## This method is used to know if there are conflicting inputs (inputs used for multiple actions) in
## the current scheme. This then is used to warn the player about this conflict.
func contains_input_event(input_event: InputEvent) -> bool:
	push_error("Error: method \"equals()\" not implemented")
	return false

## Method used for serialization. When saving a control scheme to a file, it is first turned into a
## Dictionary with the data it needs (category, name, configuration...) so it can be stored as a
## JSON file. The configuration might include the InputEvent object that triggers the action.
func get_as_dict() -> Dictionary:
	push_error("Error: method \"get_as_dict()\" not implemented")
	return {}

## Method used for deserialization. When loading a control scheme from a file, new instances of
## InputAction classes are created with the configuration from the stored JSON file. This method
## uses the data in those JSON objects to create a new instance of the InputAction.
static func new_from_dict(dict: Dictionary) -> InputAction:
	push_error("Error: method \"new_from_dict()\" not implemented")
	return null
