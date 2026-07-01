## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is the base type for the addon's model. It's a generic input configuration type that
## can hold variables and methods that will be used later to de/serialize and apply this
## configuration, but leaves the implementation to the implementing sub-classes.
@tool
class_name InputConfig
extends Resource

## Name for this InputConfig. If it's an action, it will be used as the action name. If it's a
## ControlScheme, it will be displayed in the UI with this name.
@export var name: StringName

func _init(_name: StringName) -> void:
	name = _name

## If you want to use an InputAction, this is the method to call. This method tells the InputAction
## to call Godot's Input API to configure itself there. For concrete actions, this means creating an
## action on the InputMap and assigning the input to it, for schemes or group of actions this means
## applying each InputAction individually.
func apply_config() -> void:
	push_error("Error: method \"apply_config()\" not implemented")
	return

## Method used for serialization. When saving a control scheme to a file, it is first turned into a
## Dictionary with the data it needs (category, name, configuration...) so it can be stored as a
## JSON file. The configuration might include the InputEvent object that triggers the action.
func get_as_dict() -> Dictionary:
	push_error("Error: method \"get_as_dict()\" not implemented")
	return {}

## Method used for deserialization. When loading a control scheme from a file, new instances of
## InputAction classes are created with the configuration from the stored JSON file. This method
## uses the data in those JSON objects to create a new instance of the InputAction.
static func new_from_dict(dict: Dictionary) -> InputConfig:
	push_error("Error: method \"new_from_dict()\" not implemented")
	return null
