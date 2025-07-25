extends Node
## When this script is run, it generates the default input configuration in "user://input.data"
## based on the "default_schemes" variable.

@export var default_schemes: GatoControlScheme

func _ready() -> void:
	InputRemapper.control_schemes = [default_schemes]
	InputRemapper.save_changes()
