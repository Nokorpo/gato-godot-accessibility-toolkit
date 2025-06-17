extends StaticBody3D

@export var player: Gato
@export var acorn_scene: PackedScene


func _ready() -> void:
	respawn_acorns()
	
func respawn_acorns() -> void:
	for child: Marker3D in $AcornPositions.get_children():
		var acorn: Acorn = acorn_scene.instantiate()
		acorn.scale = Vector3.ONE * 0.1
		var tween = create_tween()
		tween.tween_property(acorn,"scale", Vector3.ONE, .4)
		acorn.global_position = child.global_position
		acorn.freeze = true
		acorn.player = player
		$AcornContainer.add_child(acorn)


func _on_acorn_fall_area_body_entered(body: Node3D) -> void:
	if body is Gato:
		for acorn:RigidBody3D in $AcornContainer.get_children():
			acorn.freeze = false

func _on_acorn_fall_area_body_exited(body: Node3D) -> void:
	if body is Gato:
		if $AcornContainer.get_child_count() == 0:
			respawn_acorns()
