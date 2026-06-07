## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name RandomTimer
extends Timer

@export var minimum_wait_time: float = 1
@export var maximum_wait_time: float = 1

func _ready() -> void:
	timeout.connect(_set_next_random_wait_time)
	wait_time = randf_range(minimum_wait_time, maximum_wait_time)

func _set_next_random_wait_time() -> void:
	wait_time = randf_range(minimum_wait_time, maximum_wait_time)
