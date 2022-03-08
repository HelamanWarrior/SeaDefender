extends Node

const game_size := Vector2(256, 144)

var freeze_ms = 30

func instance_node(node: Object, location: Vector2) -> Object:
	var node_instance = node.instance()
	get_tree().current_scene.call_deferred("add_child", node_instance)
	node_instance.global_position = location
	return node_instance

func _input(_event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
