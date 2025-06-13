class_name Acorn
extends RigidBody3D

#signal grab_acorn
#
#func _on_body_entered(body: Node) -> void:
	#if body is Gato:
		#grab_acorn.emit()


func follow_the_player(player: Gato, position: int):
	var direction: Vector3 = player.global_position - global_position
	linear_velocity = position * direction
