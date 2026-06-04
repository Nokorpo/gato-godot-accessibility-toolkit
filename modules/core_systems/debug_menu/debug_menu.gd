## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

var enable_infinite_jumps: bool = false
var animation_speed: float = 1.0

func adjust_to_animation_speed(normal_speed: float) -> float:
	return lerp(1.0, normal_speed, DebugOptions.animation_speed)

func toggle_infinite_jumps(toggle: bool) -> void:
	enable_infinite_jumps = toggle
