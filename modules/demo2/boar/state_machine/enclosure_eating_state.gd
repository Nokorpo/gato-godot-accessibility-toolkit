extends StateMachineState
class_name EnclosureBoarEatingState

@onready var particles: CPUParticles3D = $"../../CPUParticles3D"
@onready var heart_particles: GPUParticles3D = $"../../HeartParticles"
var target = null
var boar: CharacterBody3D
@export var mesh: BoarMesh
@export var eating_time: float = 1.5

func _start(_state_machine: StateMachine, _node: Node) -> void:
	super(_state_machine, _node)
	boar = _node as CharacterBody3D

func _on_enter_state() -> void:
	mesh.play_animation(BoarMesh.Animations.EAT)
	particles.emitting = true
	await get_tree().create_timer(eating_time).timeout
	await animate_acorn_disappearance()
	state_machine.call_deferred("change_state", EnclosureBoarIdleState)

#TODO move to acorn code
func animate_acorn_disappearance():
	# We use this vector instead of Vector3.ZERO because setting a scale of
	# zero is not supported by Jolt Physics and a warning is thrown.
	const APPROX_ZERO: Vector3 = Vector3(0.00001, 0.00001, 0.00001)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(target, "scale", APPROX_ZERO, .2)
	tween.tween_callback(target.queue_free)
	await tween.finished

func _on_exit_state() -> void:
	target = null
	node.finished_feeding.emit()
	particles.emitting = false
