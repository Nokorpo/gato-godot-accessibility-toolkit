extends StaticBody3D

func _ready() -> void:
	for acorn:RigidBody3D in $AcornContainer.get_children():
		acorn.freeze = true


func _on_acorn_fall_area_body_entered(body: Node3D) -> void:
	if body is Gato:
		for acorn:RigidBody3D in $AcornContainer.get_children():
			acorn.freeze = false
