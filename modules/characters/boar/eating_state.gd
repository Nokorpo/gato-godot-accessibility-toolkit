extends StateMachineState
class_name BoarEatingState

@onready var particles: CPUParticles3D = $"../../CPUParticles3D"
var target = null
@export var mesh: BoarMesh
@export var eating_time: float = 1.5

func _on_enter_state() -> void:
	mesh.play_animation(BoarMesh.Animations.EAT)
	particles.emitting = true
	await get_tree().create_timer(eating_time).timeout
	await animate_acorn_disappearance()
	state_machine.call_deferred("change_state", BoarIdleState)

#TODO move to acorn code
func animate_acorn_disappearance():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(target, "scale", Vector3.ZERO, .2)
	tween.tween_callback(target.queue_free)
	await tween.finished

func _on_exit_state() -> void:
	particles.emitting = false
	target = null
