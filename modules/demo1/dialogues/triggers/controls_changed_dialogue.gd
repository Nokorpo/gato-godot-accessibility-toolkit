extends Node
## This node launches a dialogue when the controls defined in the Input Remapper are modified by the player.

@export var dialogue: DialogueContainer
@export var game_menu: CanvasLayer
@export var time_to_wait_after_controls_changed: float = 3.0

@onready var previous_dialogue := $"../AllMovesUsedDialogue"
func _ready() -> void:
	await previous_dialogue.finished # all buttons were pressed
	await DialogueSystem.dialogue_finished # previous dialogue was closed
	await InputRemapper.control_scheme_saved_to_file # controls were changed
	await game_menu.closed
	await get_tree().create_timer(time_to_wait_after_controls_changed).timeout # Give player some time to test controls
	DialogueSystem.load_dialogue(dialogue)
	queue_free()
