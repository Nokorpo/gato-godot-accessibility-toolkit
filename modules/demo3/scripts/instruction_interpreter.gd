class_name InstructionInterpreter
extends Object

enum Result { CONTINUE, STOP, WAIT_FOR_CHOICE, ERROR }

var _node: Node
var _keyword_to_instruction_map: Dictionary:
	get():
		if not _keyword_to_instruction_map:
			_keyword_to_instruction_map = {
				"SAY": SayInstruction.new(_node),
				"PLAY_ANIMATION": PlayAnimationInstruction.new(_node),
				"SET_HP": ChangeHpInstruction.new(_node),
				"STOP": StopInstruction.new(_node),
				"WAIT_FOR_CHOICE": WaitForChoiceInstruction.new(_node),
				"END": EndInstruction.new(_node)
			}
		return _keyword_to_instruction_map

func _init(node: Node):
	_node = node

func parse(line: String) -> Result:
	var words: PackedStringArray = line.split(" ", false)
	var keyword: String = words[0]
	var text: String = " ".join(words.slice(1))
	return _get_instruction(keyword).run(text)

func _get_instruction(keyword: String) -> Instruction:
	return _keyword_to_instruction_map[keyword]


class Instruction:
	var _node: Node

	func _init(node: Node):
		_node = node

	@warning_ignore("unused_parameter") # used by subclasses
	func run(value: String) -> Result:
		assert(false) #InstructionInterpreter base class cannot be used
		return Result.ERROR

class SayInstruction extends Instruction:
	func run(value: String) -> Result:
		if not _node:
			return Result.ERROR
		if not _node.narrator.visible:
			_node.narrator.show()
		_node.narrator.set_text(value)
		return Result.CONTINUE

class StopInstruction extends Instruction:
	func run(_value: String) -> Result:
		return Result.STOP

class WaitForChoiceInstruction extends Instruction:
	func run(_value: String) -> Result:
		_node.narrator.hide()
		_node.attack_button.grab_focus()
		return Result.WAIT_FOR_CHOICE

class PlayAnimationInstruction extends Instruction:
	func run(animation_name: String) -> Result:
		assert(_node.animation_player.has_animation(animation_name),
			"Demo 3 AnimationPlayer doesn't have animation with name \"%s\"" % animation_name)
		_node.animation_player.play(animation_name)
		return Result.CONTINUE

class ChangeHpInstruction extends Instruction:
	func run(value: String) -> Result:
		var words: PackedStringArray = value.split(" ", false)
		var character: String = words[0]
		var percentage: float = float(words[1])
		if character == "gato":
			_node.gato.set_hp(percentage)
		elif character == "zeta":
			_node.zeta.set_hp(percentage)
		else:
			assert(false, "Trying to change HP for unknown character \"%s\"." % character)
			return Result.ERROR
		return Result.CONTINUE

class EndInstruction extends Instruction:
	func run(_value: String) -> Result:
		_node.battle_menu.hide()
		_node.narrator.hide()
		_node.completed_demo.show_screen()
		return Result.STOP
