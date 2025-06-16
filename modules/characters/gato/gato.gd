class_name Gato
extends CharacterBody3D


func _on_item_entered(body: Node3D) -> void:
	if body is Acorn:
		var acorn: Acorn = body
		acorn.get_parent().remove_child(acorn)
		call_deferred("move_acorn_to_container", acorn)
		var collision: CollisionShape3D = acorn.find_child("CollisionShape3D")
		collision.disabled = true
		acorn.follow_the_player()

func move_acorn_to_container(acorn: Acorn):
	$ItemContainer.add_child(acorn)

func get_item_carried_count() -> int:
	return $ItemContainer.get_child_count()
