extends Label

@export var action_name: String

func _ready():
	InputRemapper.control_scheme_saved_to_file.connect(update_controls_icon)
	update_controls_icon()

func update_controls_icon():
	text = str(InputMap.action_get_events(action_name)[0].as_text())
