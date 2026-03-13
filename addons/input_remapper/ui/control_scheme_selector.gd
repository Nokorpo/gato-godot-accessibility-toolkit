extends Container

@onready var current_scheme_label: Label = $HBoxContainer/HBoxContainer/CurrentScheme
@onready var next_scheme_label: Label = $HBoxContainer/NextScheme
@onready var second_next_scheme_label: Label = $HBoxContainer/NextScheme2

func _update_ui(scheme_list: Array[GatoControlScheme], current_scheme: int) -> void:
	current_scheme_label.text = scheme_list[current_scheme].name
	next_scheme_label.text = scheme_list[(current_scheme + 1) % scheme_list.size()].name
	second_next_scheme_label.text = scheme_list[(current_scheme + 2) % scheme_list.size()].name

func _load_next_scheme() -> void:
	InputRemapper.load_next_scheme()

func _load_last_scheme() -> void:
	InputRemapper.load_previous_scheme()

func reset_config() -> void:
	InputRemapper.reset_changes()
