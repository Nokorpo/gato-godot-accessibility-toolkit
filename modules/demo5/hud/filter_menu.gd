extends Node

@export var filter_node: ColorRect
@export var filter_buttons_node: Container
@export var filter_label: Label

var current_filter: Filter = Filter.new()
var are_filters_blocked: bool = false
var filters_to_shader_index_map: int

func _ready():
	for button: FilterButton in filter_buttons_node.get_children():
		button.pressed_button.connect(select_filter)

func _input(event: InputEvent) -> void:
	if are_filters_blocked:
		_notify_filters_are_blocked()
		return
	if event.is_action_pressed("change_filter_right"):
		var next_filter: Filter.FilterType = (current_filter.value + 1) % Filter.FilterType.values().size()
		if next_filter == null:
			next_filter = Filter.FilterType.values()[0]
		select_filter(Filter.new(next_filter))
	if event.is_action_pressed("change_filter_left"):
		var next_filter: Filter.FilterType = (current_filter.value - 1) % Filter.FilterType.values().size()
		if next_filter < 0:
			next_filter = Filter.FilterType.values()[-1]
		select_filter(Filter.new(next_filter))

func select_filter(filter: Filter):
	var button: FilterButton = _get_filter_button(filter)
	var previous_button: FilterButton = _get_filter_button(current_filter)
	_set_label_text(filter)
	button.button_pressed = true
	current_filter = filter
	_apply_filter_shader(current_filter)

func _get_filter_button(filter: Filter) -> FilterButton:
	return filter_buttons_node.get_child(filter.value)

func _notify_filters_are_blocked():
	#filters are blocked feedback
	pass

func _set_label_text(filter: Filter):
	filter_label.text = filter.get_filter_name(filter.value)

func _apply_filter_shader(filter: Filter):
	pass
