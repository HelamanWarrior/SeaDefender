extends Node

const game_size := Vector2(256, 144)

const freeze_ms = 30

var player = null
var people_container = null

var last_play_score = 0
var highscore = 0

var play_tutorial = true
var mute_sounds = false
var score_data = [["1st", "JOD", 1765], ["2nd", "TOD", 1650], ["3rd", "AAA", 1400], ["4th", "POO", 1345], ["5th", "ZAC", 1265]]

var difficulty = 1
var difficulty_steps = 0
var numb_collected_people = 0 setget numb_collected_people_set

func _ready():
	randomize()

func instance_node(node: Object, location: Vector2) -> Object:
	var node_instance = node.instance()
	get_tree().current_scene.call_deferred("add_child", node_instance)
	node_instance.global_position = location
	return node_instance

func _input(_event):
	#if Input.is_action_pressed("quit"):
	#	get_tree().quit()
	pass

func numb_collected_people_set(new_value):
	numb_collected_people = clamp(new_value, 0, 7)
	
	if numb_collected_people == 7:
		GameEvent.emit_signal("full_crew")
	
	GameEvent.emit_signal("update_person_count")
