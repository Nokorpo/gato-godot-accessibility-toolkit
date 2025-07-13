extends MeshInstance3D

var green: Material
var red: Material

func _ready() -> void:
	green = StandardMaterial3D.new()
	green.albedo_color = Color.GREEN
	red = StandardMaterial3D.new()
	red.albedo_color = Color.RED
	set_surface_override_material(0, red)

func _on_button_button_toggled(toggle: bool) -> void:
	set_surface_override_material(0, green if toggle else red)
