extends Container

@onready var current_scheme_label: Label = $VBoxContainer/HBoxContainer/CurrentScheme
@onready var next_scheme_label: Label = $NextScheme
@onready var second_next_scheme_label: Label = $NextScheme2

var schemes := ["default", "left hand", "right hand"]
var current_scheme := 0

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	current_scheme_label.text = schemes[current_scheme]
	next_scheme_label.text = schemes[(current_scheme + 1) % schemes.size()]
	second_next_scheme_label.text = schemes[(current_scheme + 2) % schemes.size()]

func _load_next_scheme() -> void:
	current_scheme = (current_scheme + 1) % schemes.size()
	_update_ui()

func _load_last_scheme() -> void:
	current_scheme = (current_scheme - 1) % schemes.size()
	_update_ui()
