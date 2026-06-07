extends Node

@export var initial_sequence: Sequence
@export_category("Scene Nodes")
@export var narrator: Node
@export var gato: Node
@export var zeta: Node
@export var attack_button: Button
@export var dialogue_button: Button
@export var animation_player: AnimationPlayer
@export var completed_demo: CanvasLayer

@onready var interpreter := InstructionInterpreter.new(self)
@onready var battle_menu: Control = %BattleMenu

var _sequence: Sequence:
	set(value):
		_sequence = value
		_current_line = 0
		_current_script = value.sequence_script.split("\n", false)
var _current_line: int
var _current_script: PackedStringArray

## Used to disable input while animations are being played.
var active: bool = true
var _animation_semaphor: int = 0

func _ready():
	_sequence = initial_sequence
	battle_menu.visible = false
	attack_button.disabled = true
	dialogue_button.disabled = true
	_run_sequence()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and event.is_pressed():
		if narrator.visible:
			_on_narrator_text_box_pressed()
			get_viewport().set_input_as_handled()

func _run_sequence():
	var result: InstructionInterpreter.Result = InstructionInterpreter.Result.CONTINUE
	while result == InstructionInterpreter.Result.CONTINUE:
		if _current_line >= _current_script.size():
			_load_next_sequence()
		var line: String = _current_script[_current_line]
		result = interpreter.parse(line)
		if result == InstructionInterpreter.Result.CONTINUE:
			_current_line += 1

	if result == InstructionInterpreter.Result.STOP:
		_current_line += 1
	elif result == InstructionInterpreter.Result.WAIT_FOR_CHOICE:
		battle_menu.visible = true
		attack_button.disabled = false
		dialogue_button.disabled = false

func _load_sequence(sequence_id: Sequence.Sequences) -> Sequence:
	var file_path: StringName = Sequence.sequence_id_to_file_path(sequence_id)
	assert(FileAccess.file_exists(file_path), "Could not load Sequence in path: %s" % file_path)
	return load(file_path)

func _load_next_sequence():
	assert(_sequence is NextSequence)
	narrator.show()
	_sequence = _load_sequence(_sequence.next_sequence)

func _on_attack_button_pressed() -> void:
	if not active:
		return
	assert(_sequence is ChoiceSequence)
	battle_menu.visible = false
	attack_button.disabled = true
	dialogue_button.disabled = true
	_sequence = _load_sequence(_sequence.attack_sequence)
	_run_sequence()

func _on_dialogue_button_pressed() -> void:
	if not active:
		return
	assert(_sequence is ChoiceSequence)
	battle_menu.visible = false
	attack_button.disabled = true
	dialogue_button.disabled = true
	_sequence = _load_sequence(_sequence.dialogue_sequence)
	_run_sequence()

func _on_narrator_text_box_pressed() -> void:
	if not active:
		return
	_run_sequence()

func _on_animation_player_animation_started(_anim_name: StringName) -> void:
	_animation_semaphor += 1
	active = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_animation_semaphor -= 1
	if _animation_semaphor <= 0:
		active = true
