extends Node
## This service creates the Screen Filters UI and injects it in the running
## game.

const UI_SCENE_UID: StringName = "uid://14lvyt4uefey"
var ui: Control = null
var last_camera: Camera3D

var color_blindness_effect: ColorBlindnessShader = ColorBlindnessShader.new()

func _ready() -> void:
	await RenderingServer.frame_post_draw
	ui = (load(UI_SCENE_UID) as PackedScene).instantiate()
	ui.keycode_to_toggle_visibility = OS.find_keycode_from_string(get_key_string_from_config())
	#get_tree().root.add_child.call_deferred(ui)

#func _process(_delta):
	#var current_camera := get_viewport().get_camera_3d()
	#if last_camera != current_camera:
		#if last_camera:
			#last_camera.compositor.compositor_effects.erase(color_blindness_effect)
		#last_camera = current_camera
		#if current_camera.compositor == null:
			#current_camera.compositor = Compositor.new()
		#current_camera.compositor.compositor_effects.append(color_blindness_effect)

# TODO extract to model folder
func get_key_string_from_config() -> String:
	var config := ConfigFile.new()
	config.load("res://addons/gato_screen_filters/plugin.cfg")
	return config.get_value("default_variables", "key_to_toggle_ui_visibility", "F6")
