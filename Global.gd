extends Node

const game_size := Vector2(256, 144)

const freeze_ms = 30

var player = null
var people_container = null

var last_play_score = 0
var highscore = 0

var play_tutorial = true
var mute_sounds = true
var score_data = [["JOD", 5000], ["TOD", 3500], ["HAC", 2700], ["POO", 1600], ["ZAC", 700]]

var save_game = SaveGame.new()

var save_file = "user://savegame.tres"

var difficulty = 1
var difficulty_steps = 0
var numb_collected_people = 0 setget numb_collected_people_set

func _ready():
	randomize()
	
	GameEvent.connect("save_game", self, "update_save_values")
	
	if load_save_game() != null:
		save_game = load_save_game()
		load_save_values()

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
	
	if new_value >= 7:
		GameEvent.emit_signal("full_crew")
	
	GameEvent.emit_signal("update_person_count")

func update_save_values():
	save_game.score_data = score_data
	save_game.high_score = highscore
	save_game.last_play_score = last_play_score
	save_game.play_tutorial = play_tutorial
	save_game.mute_sounds = mute_sounds
	
	save_game()

func load_save_values():
	score_data = save_game.score_data
	highscore = save_game.high_score
	last_play_score = save_game.last_play_score
	play_tutorial = save_game.play_tutorial
	mute_sounds = save_game.mute_sounds

func save_game():
	var result = ResourceSaver.save(save_file, save_game)
	assert(result == OK)

func load_save_game():
	if ResourceLoader.exists(save_file):
		var _save_game = ResourceLoader.load(save_file)
		if _save_game is SaveGame: # make sure save file is valid
			return _save_game
		else:
			print("Invalid save file")
