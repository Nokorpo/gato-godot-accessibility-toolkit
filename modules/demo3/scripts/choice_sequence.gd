## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
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
