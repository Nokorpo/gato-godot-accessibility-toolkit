class_name EnclosureBoar
extends Boar

@export var assigned_enclosure: Enclosure.EnclosureType
var _enclosure_reached: bool = false

var normal_material: Material = load("res://modules/demo2/boar/normal_material.tres")
var highlight_material: Material = load("res://modules/demo2/boar/highlight_material.tres")

func _ready() -> void:
	deselect()

func set_enclosure_as_reached():
	if not _enclosure_reached:
		_enclosure_reached = true
		$StateMachine.change_state(EnclosureBoarFoundEnclosureState)
		finished_growing.emit()

func select() -> void:
	_set_material(highlight_material)

func deselect() -> void:
	_set_material(normal_material)

func _set_material(material: Material) -> void:
	var body: MeshInstance3D = $BoarMesh.find_child("Body", true, false)
	body.set_surface_override_material(0, material)
