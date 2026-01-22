extends Area3D
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

@onready var item_container: Node3D = $ItemContainer

## The list of items currently contained by this container. They will follow the
## container around as it moves.
var items: Array[Node3D] = []
## When an item is initially collected, it floats to the back of this container.
## Items playing this animation are stored here before moving to the [code]items[/code] array.
var _items_floating_toward_container: Array[Node3D] = []

func _physics_process(delta: float) -> void:
	for i in range(items.size()):
		if i > items.size():
			continue
		if not is_instance_valid(items[i]):
			# if an acorn is picked while a boar eats it, it might be removed while following the player, so we have to remove it from the list
			items.remove_at(i)
			continue
		var diff := item_container.global_position - items[i].global_position
		var expected_distance: float = (i+1) * item_separation
		if diff.length() >= expected_distance:
			var direction := diff.normalized()
			items[i].global_position = lerp(
				items[i].global_position,
				item_container.global_position - direction * expected_distance,
				DebugOptions.adjust_to_animation_speed(item_follow_speed * delta))

## Makes the collected item go through other items so the player isn't blocked by it
func _disable_item_physics(item: PhysicsBody3D) -> void:
	item.set_collision_mask_value(1, false)
	item.set_collision_layer_value(1, false)
	item.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	item.freeze = true

## Makes the collected item collide with other items
func _enable_item_physics(item: PhysicsBody3D) -> void:
	if not is_instance_valid(item):
		return
	item.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	item.freeze = false
	await get_tree().create_timer(.5).timeout
	if not is_instance_valid(item):
		return
	item.set_collision_mask_value(1, true)
	item.set_collision_layer_value(1, true)

## Plays a short animation that moves the collected item behind the container
func _float_item_toward_container(item: Node3D) -> Tween:
	_items_floating_toward_container.append(item)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(item, "global_position", item_container.global_position - item_container.global_basis.z.normalized() * items.size() * item_separation, .5 * DebugOptions.animation_speed)
	tween.tween_callback(_items_floating_toward_container.erase.bind(item))
	return tween

## Removes the first item from the item list and returns it.[br]
## Returns [code]null[/code] if it has collected no items.
func pop_item() -> Node3D:
	var item: RigidBody3D = items.pop_front()
	if item:
		_enable_item_physics(item)
	return item

## When a pickable item is detected, its added to the item list.[br][br]
## [b]Note:[/b] Addition is not instantaneous. The item is tweened to the back of
## the character and it won't be added to the list until the animation is finished.
func _on_body_entered(body: Node3D) -> void:
	if body is Acorn:
		if body in items or body in _items_floating_toward_container:
			# do nothing if item is already detected
			return

		_disable_item_physics(body)
		await _float_item_toward_container(body).finished
		items.append(body)
		item_collected.emit(body)
