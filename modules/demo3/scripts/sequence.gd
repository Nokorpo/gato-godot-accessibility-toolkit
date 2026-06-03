class_name Sequence
extends Resource

enum Sequences { A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S }

const SEQUENCES_DIRECTORY: StringName = &"res://modules/demo3/sequences/"

@export var sequence_id: Sequences
@export_multiline var sequence_script: String

static func sequence_id_to_file_path(_sequence_id: Sequences) -> StringName:
	return SEQUENCES_DIRECTORY+Sequences.find_key(_sequence_id)+".tres"
