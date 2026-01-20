extends Camera3D

var follow: Camera3D

func _process(delta: float) -> void:
	if follow:
		global_transform = follow.global_transform
		if not is_instance_valid(follow):
			follow = null
			print("Lost the camera")
