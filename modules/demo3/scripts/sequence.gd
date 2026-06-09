## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name Sequence
extends Resource

enum Sequences { A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U }

const SEQUENCES_DIRECTORY: StringName = &"res://modules/demo3/sequences/"

@export var sequence_id: Sequences
@export_multiline var sequence_script: String

static func sequence_id_to_file_path(_sequence_id: Sequences) -> StringName:
	return SEQUENCES_DIRECTORY+Sequences.find_key(_sequence_id)+".tres"
