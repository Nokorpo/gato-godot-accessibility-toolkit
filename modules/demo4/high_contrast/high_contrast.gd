extends Node

signal enabled
signal disabled

@export_category("Scene config")
@export var scene_root: Node

@export_category("Materials config")
@export var world_material: ShaderMaterial
@export var player_material: Material
@export var npcs_material: Material
@export var obstacles_material: Material
@export var interactable_material: Material

@onready var _ui_offset: Control = $CanvasLayer/Control/Offset
@onready var _ui_content: Control = _ui_offset.get_child(0)
var _enabled: bool = false

func _ready() -> void:
	if not scene_root:
		push_warning("This node requires a reference to the top node on the scene in \"scene_root\". The reference was null. Please, set it up.")
		return
	await scene_root.ready #wait for level ready before running this init script
	get_tree().node_added.connect(_on_node_added)
	_hide_ui()

func _hide_ui() -> void:
	var ui_size: float = _ui_content.get_rect().size.x
	_ui_offset.position.x = ui_size

func enable() -> void:
	_enabled = true
	_apply_material(scene_root)
	enabled.emit()

func disable() -> void:
	_enabled = false
	_remove_material(scene_root)
	disabled.emit()

func show_ui() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(_ui_offset, "position", Vector2.ZERO, 1.)

func _on_node_added(node: Node):
	if _enabled:
		_apply_material(node)

func _apply_material(node: Node):
	var meshes := _find_meshes_in_node_descendants(node)
	for mesh: MeshInstance3D in meshes:
		var material := _get_appropriate_material(mesh)
#		for i: int in range(mesh.mesh.get_surface_count()):
			#mesh.mesh.surface_get_material(i).next_pass = material
		for i: int in range(mesh.get_surface_override_material_count()):
			mesh.set_surface_override_material(i, material)

func _remove_material(node: Node):
	var meshes := _find_meshes_in_node_descendants(node)
	for mesh: MeshInstance3D in meshes:
		#for i: int in range(mesh.mesh.get_surface_count()):
				#mesh.mesh.surface_get_material(i).next_pass = null
		for i: int in range(mesh.get_surface_override_material_count()):
				mesh.set_surface_override_material(i, null)

func _get_appropriate_material(node: Node) -> Material:
	if _rec_find_parent_in_group(node, &"player"):
		return player_material
	if _rec_find_parent_in_group(node, &"npc"):
		return npcs_material
	if _rec_find_parent_in_group(node, &"interactable"):
		return interactable_material
	else:
		return world_material

func _rec_find_parent_in_group(node: Node, group: StringName) -> bool:
	if node.is_in_group(group):
		return true
	elif get_tree().root == node:
		return false
	else:
		return _rec_find_parent_in_group(node.get_parent(), group)

func _find_meshes_in_node_descendants(node: Node) -> Array[MeshInstance3D]:
	var meshes: Array[MeshInstance3D] = []
	for mesh: MeshInstance3D in node.find_children("", "MeshInstance3D", true, false):
		meshes.append(mesh)
	return meshes
