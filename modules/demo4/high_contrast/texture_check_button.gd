extends HBoxContainer

signal enabled
signal disabled
signal toggled(toggle_on: bool)

const BALL_INITIAL_POSITION = 4
const BALL_END_POSITION = 128 - 4 - 50

const ENABLED_BACKGROUND: Color = Color.LIGHT_YELLOW
const DISABLED_BACKGROUND: Color = Color.DIM_GRAY

@onready var button := $CheckButton
@onready var panel := $VBoxContainer/PanelContainer
@onready var ball := $VBoxContainer/PanelContainer/Panel

func _on_button_toggled(toggled_on: bool) -> void:
	button.button_pressed = toggled_on

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

	var new_pos: float = BALL_END_POSITION if toggled_on else BALL_INITIAL_POSITION
	tween.tween_property(ball, "position", Vector2(new_pos, ball.position.y), .1)

	var new_color := ENABLED_BACKGROUND if toggled_on else DISABLED_BACKGROUND
	tween.tween_property(panel.get_theme_stylebox("panel"), "bg_color", new_color, .1)

	return tween

func _input(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton \
	and input_event.button_index == MOUSE_BUTTON_LEFT \
	and input_event.pressed:
		var rect: Rect2 = panel.get_global_rect()
		if rect.has_point(get_viewport().get_mouse_position()):
			_on_button_toggled(!button.button_pressed)
