## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name Filter
extends Resource

enum FilterType { NORMAL, PROTANOPIA, DEUTERANOPIA, DEUTERANOMALÍA, TRITANOPIA, ACROMATOPSIA }

@export var value: FilterType

func _init(_value: FilterType = Filter.FilterType.NORMAL):
	value = _value

func get_filter_name(_filter: int) -> String:
	var filter_name = FilterType.find_key(_filter)
	return filter_name
