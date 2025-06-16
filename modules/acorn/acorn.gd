class_name Acorn
extends RigidBody3D

@export var player: Gato
var following_player: bool = false
var follow_speed: float = 5.0
var position_in_the_row: int = 0

func _process(delta: float) -> void:
	if following_player:
		var target_position := player.global_position + Vector3(0, 0, -position_in_the_row)
		global_position = global_position.move_toward(target_position, follow_speed * delta)

func follow_the_player() -> void:
	var tween = create_tween()
	tween.parallel().tween_property($MeshInstance3D,"scale", Vector3(), .01)
	await tween.finished
	freeze = true
	following_player = true
	position_in_the_row = player.get_item_carried_count() + 1
	tween = create_tween()
	tween.parallel().tween_property($MeshInstance3D,"scale", Vector3.ONE, .4)
