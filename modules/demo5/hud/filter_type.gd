class_name Filter
extends Resource

enum FilterType { NORMAL, PROTANOPIA, DEUTERANOPIA, DEUTERANOMALY, TRITANOPIA, ACHROMATOPSIA }

@export var value: FilterType

func _init(_value: FilterType = Filter.FilterType.NORMAL):
	value = _value

func get_filter_name(_filter: int) -> String:
	print(_filter)
	var filter_name = FilterType.find_key(_filter)
	return filter_name
