extends SubViewportContainer

@onready var _character_container: Node3D = $SubViewport/Characters

var _cached_characters: Dictionary[PackedScene, Node3D] = {}

func set_avatar(mesh: PackedScene, animation: StringName) -> void:
	for character: Node3D in _cached_characters.values():
		character.hide()

	var character := _get_or_instantiate(mesh)
	character.show()
	_set_animation(character, animation)

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

func _get_or_instantiate(mesh: PackedScene) -> Node3D:
	if mesh in _cached_characters:
		return _cached_characters[mesh]
	else:
		var instance = mesh.instantiate()
		_character_container.add_child(instance)
		_cached_characters.set(mesh, instance)
		return instance
