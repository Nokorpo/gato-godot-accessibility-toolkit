extends Node
## When this script is run, it generates the default input configuration in "user://input.data"
## based on the "default_schemes" variable.

@export var default_schemes: Array[GatoControlScheme]

func _ready() -> void:
	InputRemapper.control_schemes = default_schemes
	InputRemapper.save_changes()
	print("Control schemes saved successfully!")
	get_tree().quit()
