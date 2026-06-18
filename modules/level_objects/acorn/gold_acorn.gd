## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Area3D

signal goldacorn_collected

@onready var pick_up_dust: CPUParticles3D = $PickUpDust
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _has_been_collected: bool = false

func _on_body_entered(_body: Gato) -> void:
	if _has_been_collected:
		return
	_has_been_collected = true
	emit_signal("goldacorn_collected")
	pick_up_dust.emitting = true
	animation_player.play("pick_up")

	var tween := create_tween()
	tween.tween_property(sfx, "volume_db", -80.0, 1.0)

func _on_pick_up_dust_finished() -> void:
	self.queue_free()
