class_name Gato
extends CharacterBody3D




func _on_item_entered(body: Node3D) -> void:
	if body is Acorn:
		var acorn: Acorn = body
		$ItemContainer.add_child(acorn)
		acorn.freeze = true
		#var item_distance = 20
		#acorn.global_position = global_position 
		#acorn.global_position.z = global_position.z - item_distance * $ItemContainer.get_child_count()
