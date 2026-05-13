extends Node

signal matched_color(color: TargetColor)
signal mismatched_color(color: TargetColor)
signal focused_target(color: TargetColor, is_focused: bool)

enum TargetColor { BLUE, GREEN, RED, YELLOW, BIN }

@export var throw_path: Curve 
@onready var throwable_item_pool: ThrowableItemPool = %ThrowableItemPool
@onready var target_list: Dictionary[TargetColor, Node3D] = {
	TargetColor.BLUE: $"../Boars/BoarBlue",
	TargetColor.GREEN: $"../Boars/BoarGreen",
	TargetColor.RED: $"../Boars/BoarRed",
	TargetColor.YELLOW: $"../Boars/BoarYellow",
	TargetColor.BIN: $"../Bin"
}

var current_item: ThrowableItem: 
	get():
		return throwable_item_pool.current_item
var current_selection: TargetColor
var selected_color: TargetColor
var selection_index: int
var last_boar_selection: TargetColor
var can_throw_item: bool = true

func _ready():
	throwable_item_pool.spawn_item()
	current_selection = TargetColor.BLUE
	emit_signal("focused_target", TargetColor.find_key(last_boar_selection), true)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && can_throw_item:
		selected_color = current_selection
		can_throw_item = false
		_throw_item()

	if current_selection == TargetColor.BIN:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			current_selection = last_boar_selection
			emit_signal("focused_target", TargetColor.find_key(last_boar_selection), false)
			emit_signal("focused_target", TargetColor.find_key(current_selection), true)
		return

	if Input.is_action_just_pressed("ui_left"):
		select_left_boar()
	if  Input.is_action_just_pressed("ui_right"):
		select_right_boar()
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		last_boar_selection = current_selection
		current_selection = TargetColor.BIN
		emit_signal("focused_target", TargetColor.find_key(last_boar_selection), false)
		emit_signal("focused_target", TargetColor.find_key(current_selection), true)

func _animate_item_launch():
	var tween: Tween = current_item.item_node.create_tween()
	tween.set_parallel(true)
	tween.tween_property(current_item.item_node, 'global_position:x', target_list[current_selection].find_child("Offset", true).global_position.x, 0.9)
	tween.tween_property(current_item.item_node, 'global_position:z', target_list[current_selection].find_child("Offset", true).global_position.z, 0.9)
	tween.tween_method(_set_current_item_height, 0.0, 1.0, 1.0)
	await tween.finished

func _throw_item():
	current_item.stop_anim_player()
	await _animate_item_launch()
	_check_color_match()
	await get_tree().create_timer(0.3).timeout
	current_item.remove_item()
	throwable_item_pool.spawn_item()
	can_throw_item = true

func _set_current_item_height(weight: float):
	current_item.item_node.position.y = throw_path.sample(weight)

func select_left_boar():
	selection_index -= 1
	if selection_index < 0:
		selection_index = target_list.size() - 2
	current_selection = selection_index as TargetColor
	emit_signal("focused_target", TargetColor.find_key(last_boar_selection), false)
	emit_signal("focused_target", TargetColor.find_key(current_selection), true)

func select_right_boar():
	selection_index += 1
	if selection_index >= target_list.size() - 1:
		selection_index = 0
	current_selection = selection_index as TargetColor
	emit_signal("focused_target", TargetColor.find_key(last_boar_selection), false)
	emit_signal("focused_target", TargetColor.find_key(current_selection), true)

func _check_color_match():
	if str(current_item.matching_color) == TargetColor.find_key(selected_color):
		emit_signal("matched_color", TargetColor.find_key(selected_color))
	else:
		emit_signal("mismatched_color", TargetColor.find_key(selected_color))
func _physics_process(_delta):
	if Input.is_action_just_pressed("jump"):
		var current_item = throwable_item_pool.current_item.item_node
		current_item.position.z += -0.5
		await get_tree().create_timer(1).timeout
		throwable_item_pool.current_item.remove_item()
		throwable_item_pool.spawn_item()
