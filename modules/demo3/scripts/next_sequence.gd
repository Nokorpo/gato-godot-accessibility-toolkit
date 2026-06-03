class_name NextSequence
extends Sequence

@export var next_sequence: Sequence.Sequences

func _to_string() -> String:
	var current_name: String = Sequence.Sequences.find_key(sequence_id)
	var next_name: String = Sequence.Sequences.find_key(next_sequence)
	return "Sequence %s(\n%s\n) -> %s" % [current_name, sequence_script.indent("\t"), next_name]
