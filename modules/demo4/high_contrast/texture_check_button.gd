extends HBoxContainer

signal enabled
signal disabled
signal toggled(toggle_on: bool)

const ENABLED_BACKGROUND: Color = Color.LIGHT_YELLOW
const DISABLED_BACKGROUND: Color = Color.DIM_GRAY

@onready var _button := $CheckButton
@onready var _panel := $MarginContainer/VBoxContainer/PanelContainer
@onready var _ball := $MarginContainer/VBoxContainer/PanelContainer/Panel

var _ball_initial_horizontal_position: float
var _ball_final_horizontal_position: float

func _ready() -> void:
	# wait required for Godot to calculate the size of `_panel`
	await get_tree().process_frame
	_ball_initial_horizontal_position = _ball.position.x
	_ball_final_horizontal_position = _panel.size.x - _ball.size.x - _ball.position.x

func _on_button_toggled(toggled_on: bool) -> void:
	_button.button_pressed = toggled_on

	_animate_transition(toggled_on)
	if toggled_on:
		enabled.emit()
		toggled.emit(true)
	else:
		disabled.emit()
		toggled.emit(false)

func _animate_transition(toggled_on: bool) -> Tween:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

	var new_pos: float = _ball_final_horizontal_position if toggled_on else _ball_initial_horizontal_position
	tween.tween_property(_ball, "position", Vector2(new_pos, _ball.position.y), .1)

	var new_color := ENABLED_BACKGROUND if toggled_on else DISABLED_BACKGROUND
	tween.tween_property(_panel.get_theme_stylebox("panel"), "bg_color", new_color, .1)

	return tween

func _input(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton \
	and input_event.button_index == MOUSE_BUTTON_LEFT \
	and input_event.pressed:
		var rect: Rect2 = _panel.get_global_rect()
		if rect.has_point(get_viewport().get_mouse_position()):
			_on_button_toggled(!_button.button_pressed)
