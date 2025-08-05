extends Node

var enable_infinite_jumps: bool = false
var animation_speed: float = 1.0

func adjust_to_animation_speed(normal_speed: float) -> float:
	return lerp(1.0, normal_speed, DebugOptions.animation_speed)

func toggle_infinite_jumps(toggle: bool) -> void:
	enable_infinite_jumps = toggle
