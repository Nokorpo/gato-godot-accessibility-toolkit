extends Area3D


func get_acorn_in_range() -> Node3D:
	for body in self.get_overlapping_bodies():
		if body is Acorn:
			return body
	return null
