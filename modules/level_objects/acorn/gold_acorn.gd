## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Area3D

signal goldacorn_collected

@onready var pick_up_dust: CPUParticles3D = $PickUpDust
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(_body: Gato) -> void:
	emit_signal("goldacorn_collected")
	pick_up_dust.emitting = true
	animation_player.play("pick_up")

func _on_pick_up_dust_finished() -> void:
	self.queue_free()
