extends Container

@onready var current_scheme_label: Label = $VBoxContainer/HBoxContainer/CurrentScheme
@onready var next_scheme_label: Label = $NextScheme
@onready var second_next_scheme_label: Label = $NextScheme2

var schemes := ["default", "left hand", "right hand"]

func _ready() -> void:
	schemes = InputRemapper.control_schemes
	_update_ui()

func _update_ui() -> void:
	current_scheme_label.text = schemes[InputRemapper.current_control_scheme_index].name
	next_scheme_label.text = schemes[(InputRemapper.current_control_scheme_index + 1) % schemes.size()].name
	second_next_scheme_label.text = schemes[(InputRemapper.current_control_scheme_index + 2) % schemes.size()].name

func _load_next_scheme() -> void:
	InputRemapper.load_next_scheme()
	_update_ui()

func _load_last_scheme() -> void:
	InputRemapper.load_previous_scheme()
	_update_ui()
