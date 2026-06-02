class_name ChoiceSequence
extends Sequence

@export var attack_sequence: Sequence.Sequences
@export var dialogue_sequence: Sequence.Sequences

func _to_string() -> String:
	return "Sequence %s(\n%s\n) -> Attack: %s, Dialogue: %s" % [
		Sequence.Sequences.find_key(sequence_id),
		sequence_script.indent("\t"),
		Sequence.Sequences.find_key(attack_sequence),
		Sequence.Sequences.find_key(dialogue_sequence)
	]
