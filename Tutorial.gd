extends Node2D

var shark = preload("res://Shark.tscn")

func _ready():
	GameEvent.connect("instance_tutorial_shark", self, "instance_shark")
	
	if Global.player != null:
		Global.player.current_state = Global.player.states.TUTORIAL
	
	GameEvent.emit_signal("toggle_points_visibility", false)
	GameEvent.emit_signal("toggle_crew_visiblity", false)
	GameEvent.emit_signal("toggle_oxygen_visiblity", false)

func instance_shark():
	Global.instance_node(shark, Vector2(-50, 85))
	var shark_instance = Global.instance_node(shark, Vector2(320, 85))
	shark_instance.velocity.x = -shark_instance.velocity.x

