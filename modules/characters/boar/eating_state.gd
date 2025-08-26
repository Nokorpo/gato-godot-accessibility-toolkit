extends StateMachineState
class_name BoarEatingState

@onready var particles: CPUParticles3D = $"../../CPUParticles3D"
@onready var heart_particles: GPUParticles3D = $"../../HeartParticles"
var target = null
var boar: CharacterBody3D
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
	boar = (node as CharacterBody3D)
	boar.scale = Vector3(1.5,1.5,1.5)
	boar.rotate(Vector3.UP, .1)
	heart_particles.emitting = true
	particles.emitting = false
	target = null
	node.finished_feeding.emit()
