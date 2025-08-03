extends Node3D

static var acorn_scene: PackedScene = load("res://modules/level_objects/acorn/acorn.tscn")

@onready var spawners: Node3D = $AcornSpawners
@onready var spawn_cooldown: Timer = $SpawnerCooldown
@onready var spawn_cooldown_time: float = spawn_cooldown.wait_time

func _on_body_entered(body: Node3D) -> void:
	if body is Gato and spawn_cooldown.is_stopped():
		spawn_acorns()
		spawn_cooldown.start(spawn_cooldown_time)

func spawn_acorns() -> void:
	for point: Node3D in spawners.get_children():
		var acorn: Node3D = acorn_scene.instantiate()
		add_child(acorn)
		acorn.global_position = point.global_position
