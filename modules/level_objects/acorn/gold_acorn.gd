extends Area3D

@onready var pick_up_dust: CPUParticles3D = $PickUpDust
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(_body: Gato) -> void:
	pick_up_dust.emitting = true
	animation_player.play("pick_up")

func _on_pick_up_dust_finished() -> void:
	self.queue_free()
