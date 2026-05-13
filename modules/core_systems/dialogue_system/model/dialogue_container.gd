class_name DialogueContainer
extends Resource
## Resource that represents an entire dialogue. It's basically a list of messages.

## The list of DialogueMessages that
@export var messages: Array[DialogueMessage] = []

## Get all unique meshes that this Dialogue will need. It can be used to load the meshes when the
## dialogue is first loaded and reusing them later, saving up some processing time and memory later.
func get_all_meshes() -> Array[PackedScene]:
	var meshes := messages.map(func(it: DialogueMessage): return it.mesh)
	var unique_meshes: Array[PackedScene] = []
	for mesh in meshes:
		if mesh not in unique_meshes:
			unique_meshes.append(mesh)
	return unique_meshes
