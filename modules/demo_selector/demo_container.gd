extends GridContainer

var demo_list_resource: DemoList = load("res://modules/demo_selector/demo_list.tres")

func _ready() -> void:
	for i in demo_list_resource.demos:
		add_child(Node.new())
