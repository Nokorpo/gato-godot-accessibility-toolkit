extends CanvasLayer

@onready var material: ShaderMaterial = $Filter.material

func _on_filter_selected(index: int) -> void:
	_set_filter_on_shader(index)

func _set_filter_on_shader(index: int) -> void:
	material.set_shader_parameter("type", index)
