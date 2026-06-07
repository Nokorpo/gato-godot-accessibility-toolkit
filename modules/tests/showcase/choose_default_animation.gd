## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
@tool
extends Node

@export var animation_name: String:
	set(value):
		animation_name = value
		_update_animation.call_deferred()

func _ready() -> void:
	_update_animation.call_deferred()

func _update_animation():
	var animations: AnimationPlayer = get_parent().find_child("AnimationPlayer")
	animations.play(animation_name)
