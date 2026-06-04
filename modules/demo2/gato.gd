extends Gato

@onready var boar_detector: Area3D = $BoarDetector

var _boars_in_range: Array[EnclosureBoar] = []
var _selected_boar: EnclosureBoar = null

func _ready() -> void:
	boar_detector.body_entered.connect(_on_body_entered)
	boar_detector.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if _boars_in_range.size() < 2:
		# we don't care when there is only one boar,
		# it will be the only selectable boar
		return
	var closest_index: int = 0
	var closest_distance: float = INF
	for i in range(_boars_in_range.size()):
		var boar: Node3D = _boars_in_range[i]
		var distance: float = global_position.distance_to(boar.global_position)
		if closest_distance > distance:
			closest_index = i
			closest_distance = distance
	if _selected_boar:
		_selected_boar.deselect()
	_selected_boar = _boars_in_range[closest_index]
	_selected_boar.select()

func _on_body_entered(body: PhysicsBody3D) -> void:
	if body is EnclosureBoar:
		_boars_in_range.append(body)
		if _selected_boar == null and _boars_in_range.size() == 1:
			body.select()

func _on_body_exited(body: PhysicsBody3D) -> void:
	if body in _boars_in_range:
		_boars_in_range.remove_at(_boars_in_range.find(body))
		body.deselect()
