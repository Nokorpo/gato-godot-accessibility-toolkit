extends Control

@export var time_to_reach_new_hp_value: float = 1.
@export var hp_bar: ProgressBar

func set_hp(value: float) -> void:
	var tween := create_tween()
	tween.tween_property(hp_bar, "value", value, time_to_reach_new_hp_value)
