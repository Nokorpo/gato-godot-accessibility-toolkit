class_name Gato
extends CharacterBody3D


func _on_item_entered(body: Node3D) -> void:
	if body is Acorn:
		var acorn: Acorn = body
		acorn.get_parent().remove_child(acorn)
		call_deferred("move_acorn_to_container", acorn)
		acorn.follow_the_player()

func move_acorn_to_container(acorn: Acorn):
	$ItemContainer.add_child(acorn)

func get_item_carried_count() -> int:
	return $ItemContainer.get_child_count()
	
func get_item_position(item : Acorn) -> int:
	for i:Acorn in $ItemContainer.get_children():
		if i == item:
			return i.get_index()
	return 0
