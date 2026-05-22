extends Control

signal appeared
signal disappeared

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	get_child(0).modulate = Color.TRANSPARENT

func _on_visibility_changed():
	if visible:
		create_tween().tween_property(get_child(0), "modulate", Color.WHITE, .25)
		appeared.emit()
	else:
		create_tween().tween_property(get_child(0), "modulate", Color.TRANSPARENT, .25)
		disappeared.emit()

func _is_back_input(event: InputEvent) -> bool:
	return (
		event is InputEventKey and event.keycode == KEY_ESCAPE \
		or event is InputEventJoypadButton and event.button_index == JOY_BUTTON_B
	) and event.is_pressed()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if _is_back_input(event):
		visible = false
		get_viewport().set_input_as_handled()
	# else: don't set input as handled so the game can handle it
