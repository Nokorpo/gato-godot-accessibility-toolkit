extends Control

@onready var input_remapper_ui: InputRemapperUI = get_parent()

signal appeared
signal disappeared

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	get_child(0).modulate = Color.TRANSPARENT
	$PanelContainer/VBoxContainer/RowNavigationContainer/BackButton.pressed.connect(_on_back)
	$PanelContainer/VBoxContainer/RowNavigationContainer2/SaveAndExitButton.pressed.connect(_on_save_and_exit)
	$PanelContainer/VBoxContainer/RowNavigationContainer3/ExitWithoutSavingButton.pressed.connect(_on_exit_without_saving)

func _on_visibility_changed():
	if visible:
		create_tween().tween_property(get_child(0), "modulate", Color.WHITE, .25)
		appeared.emit()
	else:
		create_tween().tween_property(get_child(0), "modulate", Color.TRANSPARENT, .25)
		disappeared.emit()

func _on_back() -> void:
	visible = false

func _on_save_and_exit() -> void:
	input_remapper_ui.save_changes()
	input_remapper_ui.close()

func _on_exit_without_saving() -> void:
	input_remapper_ui.close()
