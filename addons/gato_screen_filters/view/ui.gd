extends CanvasLayer

@onready var option_button: OptionButton = $Panel/MarginContainer/VBoxContainer/ColorBlindness/OptionButton
@onready var material: ShaderMaterial = $Filter.material

var is_toggle_visibility_just_pressed: bool = true
var keycode_to_toggle_visibility: Key

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == keycode_to_toggle_visibility:
		if event.is_pressed() and is_toggle_visibility_just_pressed:
			visible = !visible
			is_toggle_visibility_just_pressed
		elif event.is_released():
			is_toggle_visibility_just_pressed = true

func _on_filter_selected(index: int) -> void:
	_set_filter_on_shader(index)

func _set_filter_on_shader(index: int) -> void:
	material.set_shader_parameter("type", index)
