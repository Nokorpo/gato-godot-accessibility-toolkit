extends Node3D
## This node detects when an Acorn enters its detection area, then makes it follow it.[br][br]
## This is used by the player character so that it can gather acorns and have them following it around.

## Signal emitted when an item is collected and it has been put in the items list.[br][br]
## [b]Note:[/b] this signal is only emitted when the animation that moves the item behind the
## container has finished.
signal item_collected(item: Node3D)

## Separation between each item. Items will try to follow the container so they are at a distance of
## [code]item_separation[/code] times their position in the item list (eg. for the 3rd item: [code]item_separation * 3[/code]).
@export var item_separation: float = 0.5
## The speed at which the items follow the container.
@export var item_follow_speed: float = 4.0

var items: Array[Node3D] = []
var items_floating_toward_container: Array[Node3D] = []

func _physics_process(delta: float) -> void:
	for i in range(items.size()):
		var diff := global_position - items[i].global_position
		var expected_distance: float = (i+1) * item_separation
		if diff.length() >= expected_distance:
			var direction := diff.normalized()
			items[i].global_position = lerp(
				items[i].global_position,
				global_position - direction * expected_distance,
				DebugMenu.adjust_to_animation_speed(item_follow_speed * delta))

## Makes the collected item go through other items so the player isn't blocked by it
func _disable_item_physics(item: PhysicsBody3D) -> void:
	item.set_collision_mask_value(1, false)
	item.set_collision_layer_value(1, false)
	item.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	item.freeze = true

## Plays a short animation that moves the collected item behind the container
func _float_item_toward_container(item: Node3D) -> Tween:
	items_floating_toward_container.append(item)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(item, "global_position", global_position - global_basis.z.normalized() * items.size() * item_separation, .5 * DebugMenu.animation_speed)
	tween.tween_callback(func(): items_floating_toward_container.erase(item))
	return tween

func _on_item_detection_area_body_entered(body: Node3D) -> void:
	if body is Acorn:
		if body in items or body in items_floating_toward_container:
			# do nothing if item is already detected
			return

		_disable_item_physics(body)
		await _float_item_toward_container(body).finished
		items.append(body)
		item_collected.emit(body)
