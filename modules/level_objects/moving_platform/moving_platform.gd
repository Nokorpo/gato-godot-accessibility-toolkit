extends Node3D
## This node moves its parent node when it receives a signal.[br]
## [br]
## It expects its parent to extend Node3D. The destination passed as an export
## should also be any type extending Node3D, like for instance a Marker3D.

signal target_reached

@export var travel_time: float = 2.0
@export var destination_node: Node3D

var node_to_move: Node3D = null
var origin: Vector3 = Vector3.ZERO
var destination: Vector3
var is_going_to_destination: bool = false

var _tween: Tween

func _ready() -> void:
	if get_parent() is Node3D:
		# This condition is used to avoid errors when launching this scene alone
		node_to_move = get_parent()
		origin = node_to_move.global_position
	if destination_node != null:
		destination = destination_node.global_position

func _ready() -> void:
	if get_parent() is Node3D:
		# This condition is used to avoid errors when launching this scene alone
		node_to_move = get_parent()
		origin = node_to_move.global_position
	if destination_node != null:
		destination_node.global_position

## If the node is currently in the origin or moving towards the origin, it will
## travel towards the destination. If it is in the destination or traveling
## towards the destination, it will travel towards the origin instead.
func travel_toggle() -> void:
	is_going_to_destination = !is_going_to_destination
	var target := destination if is_going_to_destination else origin
	_animate_movement_to(target)

## Makes the parent node travel towards the origin.
func travel_to_origin() -> void:
	is_going_to_destination = false
	_animate_movement_to(origin)

## Makes the parent node travel towards the destination.
func travel_to_destination() -> void:
	is_going_to_destination = true
	_animate_movement_to(destination)

func _animate_movement_to(target: Vector3) -> void:
	if _tween != null:
		_tween.kill()

	var speed := travel_time / (destination - origin).length()
	var time := speed * (target - global_position).length()
	_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.tween_property(node_to_move, "global_position", target, time)
	_tween.tween_callback(target_reached.emit)
