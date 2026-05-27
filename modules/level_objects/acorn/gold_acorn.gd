extends Area3D

signal goldacorn_collected

@onready var pick_up_dust: CPUParticles3D = $PickUpDust
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _has_been_collected: bool = false

func _on_body_entered(_body: Gato) -> void:
	if _has_been_collected:
		return
	_has_been_collected = true
	emit_signal("goldacorn_collected")
	pick_up_dust.emitting = true
	animation_player.play("pick_up")

func _on_pick_up_dust_finished() -> void:
	self.queue_free()
