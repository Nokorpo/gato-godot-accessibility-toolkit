## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name SceneLoader
extends CanvasLayer
## Manages the changing the main scene

## Called when the new scene is loaded
signal scene_loaded(new_scene: Node)

## Load a new scene and delete another
func load_scene(old_scene: Node, new_scene: String) -> void:
	set_process_mode(PROCESS_MODE_ALWAYS)

	$Transition.modulate = Color.TRANSPARENT
	var transition: Tween = create_tween()
	transition.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	transition.tween_property($Transition, "modulate", Color.WHITE, 0.3)

	await transition.finished

	var loaded_scene := load(new_scene)
	var new_loaded_scene: Node = loaded_scene.instantiate()
	old_scene.queue_free()
	old_scene.add_sibling(new_loaded_scene)
	scene_loaded.emit(new_scene)

	await get_tree().create_timer(0.5).timeout

	transition = create_tween()
	transition.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	transition.tween_property($Transition, "modulate", Color.TRANSPARENT, 0.3)

	await transition.finished

	queue_free()

## Creates a new scene loader that will load a new scene and delete another
static func create_scene_loader(old_scene: Node, new_scene: String) -> SceneLoader:
	if _any_scene_loader_exists(old_scene):
		return
	var scene_loader_scene = load("uid://pjr6xchvcu17")
	var new_scene_loader = scene_loader_scene.instantiate()
	old_scene.get_tree().root.add_child(new_scene_loader)
	new_scene_loader.load_scene(old_scene, new_scene)
	return new_scene_loader

## returns true if any other SceneLoader exists
static func _any_scene_loader_exists(old_scene: Node) -> bool:
	for child: Node in old_scene.get_tree().root.get_children():
		if child is SceneLoader:
			return true
	return false
