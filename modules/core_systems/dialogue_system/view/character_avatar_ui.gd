extends SubViewportContainer

@onready var _character_container: Node3D = $SubViewport/Characters

var _cached_characters: Dictionary[PackedScene, Node3D] = {}

func set_avatar(mesh: PackedScene, animation: StringName, face: StringName) -> void:
	for character: Node3D in _cached_characters.values():
		character.hide()

	var character := _get_or_instantiate(mesh)
	character.show()
	_set_animation(character, animation)
	_set_face(character, face)

func _set_animation(character: Node3D, animation: StringName) -> void:
	if animation.is_empty():
		return
	if character.has_method("play_animation_name"):
		character.play_animation_name(animation)
	else:
		var anim_tree: AnimationTree = character.get_node_or_null(^"AnimationTree")
		var anim_player: AnimationPlayer = character.get_node_or_null(^"AnimationPlayer")
		if anim_player:
			anim_player.play(animation)
			return
		if anim_tree:
			anim_tree["parameters/playback"].travel(animation)
		elif anim_player:
			anim_player.play(animation)
		else:
			push_error("ERROR: Cannot set animation with name '%s' on character '%s'. It has no way to set animations." % [animation, character])

func _set_face(character: Node3D, face: StringName) -> void:
	if face.is_empty():
		return
	if character.has_method("set_face"):
		character.set_face_name(face)
	else:
		push_error("ERROR: Cannot set face with name '%s' on character '%s'. It has no way to set its face." % [face, character])

func _get_or_instantiate(mesh: PackedScene) -> Node3D:
	if mesh in _cached_characters:
		return _cached_characters[mesh]
	else:
		var instance = mesh.instantiate()
		_make_visible_only_in_dialogue_ui(instance)
		_character_container.add_child(instance)
		_cached_characters.set(mesh, instance)
		return instance

## The only meshes drawn to the Character Container viewport are those in layer
## 10 ("Dialogue"). Therefore, this mesh must be added to it and removed from
## the default layer 1.
func _make_visible_only_in_dialogue_ui(node: Node3D):
	for mesh: MeshInstance3D in node.find_children("*", "MeshInstance3D"):
		mesh.set_layer_mask_value(1, false)
		mesh.set_layer_mask_value(10, true)
