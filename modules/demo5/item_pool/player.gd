extends Node

@onready var throwable_item_pool : ThrowableItemPool = %ThrowableItemPool

func _ready():
	throwable_item_pool.spawn_item()

func _physics_process(_delta):
	if Input.is_action_just_pressed("jump"):
		var current_item = throwable_item_pool.current_item.item_node
		current_item.position.z += -0.5
		await get_tree().create_timer(1).timeout
		throwable_item_pool.current_item.remove_item()
		throwable_item_pool.spawn_item()
