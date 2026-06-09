## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Control

@export var time_to_reach_new_hp_value: float = 1.
@export var hp_bar: ProgressBar

func set_hp(value: float) -> void:
	var tween := create_tween()
	tween.tween_property(hp_bar, "value", value, time_to_reach_new_hp_value)
