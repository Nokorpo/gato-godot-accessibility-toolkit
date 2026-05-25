extends Node

@export var filter_node: ColorRect
@export var filter_buttons_node: Container
@export var filter_label: Label

var current_filter: Filter = Filter.new()
var are_filters_blocked: bool
var filters_to_shader_index_map: Array = [
	0, #Filter.FilterType.NORMAL
	1, #Filter.FilterType.PROTANOPIA
	3, #Filter.FilterType.DEUTERANOPIA
	4, #Filter.FilterType.DEUTERANOMALY
	5, #Filter.FilterType.TRITANOPIA
	7, #Filter.FilterType.ACHROMATOPSIA
]

func _ready():
	for button: FilterButton in filter_buttons_node.get_children():
		button.pressed_button.connect(select_filter)
	block_filters()

func _input(event: InputEvent) -> void:
	if are_filters_blocked and (event.is_action_pressed("change_filter_left") or event.is_action_pressed("change_filter_right")):
		_notify_filters_are_blocked()
		return
	if event.is_action_pressed("change_filter_right"):
		var next_filter: Filter.FilterType = (current_filter.value + 1) % Filter.FilterType.values().size() as Filter.FilterType
		if next_filter == null:
			next_filter = Filter.FilterType.values()[0]
		select_filter(Filter.new(next_filter))
	if event.is_action_pressed("change_filter_left"):
		var next_filter: Filter.FilterType = (current_filter.value - 1) % Filter.FilterType.values().size() as Filter.FilterType
		if next_filter < 0:
			next_filter = Filter.FilterType.values()[-1]
		select_filter(Filter.new(next_filter))

func select_filter(filter: Filter):
	if !are_filters_blocked:
		var button: FilterButton = _get_filter_button(filter)
		_set_label_text(filter)
		button.button_pressed = true
		current_filter = filter
		_apply_filter_shader(current_filter)
	else:
		_notify_filters_are_blocked()

func _get_filter_button(filter: Filter) -> FilterButton:
	return filter_buttons_node.get_child(filter.value)

func _notify_filters_are_blocked():
	#filters are blocked feedback
	pass

func _set_label_text(filter: Filter):
	filter_label.text = filter.get_filter_name(filter.value)

func _apply_filter_shader(filter: Filter):
	if filter.value == Filter.FilterType.NORMAL:
		filter_node.visible = false
	else:
		filter_node.visible = true
		var index: int = filters_to_shader_index_map[filter.value]
		filter_node.material.set_shader_parameter("type", index)

func block_filters():
	are_filters_blocked = true
	for button: FilterButton in filter_buttons_node.get_children():
		button.disable()

func unblock_filters():
	are_filters_blocked = false
	for button: FilterButton in filter_buttons_node.get_children():
		button.enable()
