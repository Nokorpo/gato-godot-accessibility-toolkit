class_name DialogueContainer
extends Resource

@export var messages: Array[DialogueMessage] = []

func get_all_meshes() -> Array[PackedScene]:
	var meshes := messages.map(func(it: DialogueMessage): return it.mesh)
	var unique_meshes: Array[PackedScene] = []
	for mesh in meshes:
		if mesh not in unique_meshes:
			unique_meshes.append(mesh)
	return unique_meshes
