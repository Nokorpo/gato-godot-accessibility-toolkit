extends Control

@onready var option_button: OptionButton = $ColorBlindness/OptionButton
@onready var filter: SubViewportContainer = $CanvasLayer/SubViewportContainer
@onready var camera: Camera3D = $CanvasLayer/SubViewportContainer/SubViewport/Camera3D

var is_toggle_visibility_just_pressed: bool = true
var keycode_to_toggle_visibility: Key

func _ready() -> void:
	await RenderingServer.frame_post_draw
	#if get_viewport().get_camera_3d():
		#var viewport := filter.get_child(0)
		#viewport.canvas_cull_mask = get_viewport().canvas_cull_mask
		#var camera3 := get_viewport().get_camera_3d()
		#camera.follow = camera3
		#camera.cull_mask = camera3.cull_mask
		#camera.fov = camera3.fov

	#_on_filter_selected(1)
	option_button.connect("item_selected", _on_filter_selected)
	#filter.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == keycode_to_toggle_visibility:
		if event.is_pressed() and is_toggle_visibility_just_pressed:
			visible = !visible
			is_toggle_visibility_just_pressed
		elif event.is_released():
			is_toggle_visibility_just_pressed = true

func _get_current_compositor_or_create() -> Compositor:
	var viewport := get_viewport()
	if viewport:
		var camera3d := viewport.get_camera_3d()
		var compositor := Compositor.new()
		camera3d.compositor = compositor
		return compositor
	return null

func _get_existing_color_blindness_effect_or_create() -> Variant:
	var compositor := _get_current_compositor_or_create()
	var effects: Array[CompositorEffect] = compositor.compositor_effects.filter(func(it): it is ColorBlindnessShader)
	if effects.size() > 1:
		push_error("Found multiple color blindness effects. This shouldn't happen, please report it!")
		return Error.ERR_BUG
	elif effects.size() == 1:
		return effects[0]
	else:
		var effect = ColorBlindnessShader.new()
		compositor.compositor_effects.append(effect)
		return effect

func _on_filter_selected(index: int) -> void:
	if index == 0:
		filter.visible = false
	else:
		filter.visible = true
	var effect := _get_existing_color_blindness_effect_or_create()
	if effect is Error and effect == Error.ERR_BUG:
		push_error("Could not set the color blindness type for missing or conflicting Compositor.")
		return
	effect.color_blindness_type = index
	_set_filter_on_shader(index)

func _set_filter_on_shader(index: int) -> void:
	filter.material.set_shader_parameter("type", index)
