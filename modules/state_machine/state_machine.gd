@tool
extends Node
class_name StateMachine

const PRINT_DEBUG_MESSAGES: bool = false

@onready var node: Node = $".."
var states: Array[StateMachineState]
var current_state: StateMachineState = null

func _ready() -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings()
		connect("child_entered_tree", update_configuration_warnings.unbind(1))
		connect("child_exiting_tree", update_configuration_warnings.unbind(1))
	else:
		initialize_node_state_instances()

func initialize_node_state_instances() -> void:
	for child in get_children():
		if is_instance_of(child, StateMachineState):
			child._start(self, node)
			states.append(child)
	current_state = states[0]
	current_state.active = true
	current_state.process_mode = Node.PROCESS_MODE_INHERIT
	current_state._on_enter_state()

## Change to a new state. This method will wait until the next frame
## to run the state change. This is done to avoid weird cases where
## a state is changed before its _on_enter or _en_leave methods can
## be executed.
func change_state(state_type: Variant) -> void:
	if PRINT_DEBUG_MESSAGES:
		print("Change from state %s to %s" % [
			current_state.get_script().get_global_name(),
			state_type.get_global_name()
		])
		var stack = get_stack().slice(1)[0]
		var string_format: String = "[color=66CCFF]%-12s - Caller %s:%s"
		print_rich(string_format % [_get_time(), stack["source"], stack["line"]])

	current_state.active = false
	call_deferred("_change_state", state_type)

static func _get_time() -> String:
	var time: float = Time.get_unix_time_from_system()
	@warning_ignore("narrowing_conversion")
	var hhmmss: String = Time.get_time_string_from_unix_time(time)
	var millis: int = floor((fmod(time,1)) * 1000)
	return "%s.%s" % [hhmmss, str(millis)]

func _change_state(state_type: Variant) -> void:
	var state = null
	for item in states:
		if item.get_script().get_global_name() == state_type.get_global_name():
			state = item
	if state == null:
		push_error("Could not change state. There is no state of type %s." % state_type)
	current_state._on_exit_state()
	current_state.active = false
	current_state.process_mode = Node.PROCESS_MODE_DISABLED
	current_state = state
	current_state.process_mode = Node.PROCESS_MODE_INHERIT
	current_state.active = true
	current_state._on_enter_state()

func is_current_state(state_type: Variant) -> bool:
	return current_state.get_script().get_global_name() == state_type.get_global_name()

## Represents an abstract "step", like the tick of a clock. It can be
## used in a state machine to reduce its CPU cost or to tie the execution
## to a timer/event instead of the _process or _physics_process callbacks.
func _tick() -> void:
	if current_state != null and current_state.has_method("tick"):
		current_state.tick()

## Pass-through of the _process engine callback.
func _process(delta: float) -> void:
	if current_state != null and current_state.has_method("_process"):
		current_state._process(delta)

## Pass-through of the _physics_process engine callback.
func _physics_process(delta: float) -> void:
	if current_state != null and current_state.has_method("_physics_process"):
		current_state._physics_process(delta)

func _get_configuration_warnings():
	var errors = ["The StateMachine requires at least one StateMachineState child to work."]
	for child in get_children():
		if is_instance_of(child, StateMachineState):
			errors = []
	return errors
