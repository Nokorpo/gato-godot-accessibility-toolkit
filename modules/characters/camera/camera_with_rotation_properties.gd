extends Camera3D

@onready var horizontal_axis: Node3D = $"../.."
@onready var vertical_axis: Node3D = $".."

func get_horizontal_rotation() -> float:
	return horizontal_axis.rotation.y

func get_vertical_rotation() -> float:
	return vertical_axis.rotation.x
