extends Control

const TEXT_OPTIONS = [
	"Welcome to the Tutorial", 
	"Start by using the controls above", 
	"Awesome!", 
	"Sharks incoming! you know what to do.", 
	"Great Work!",
	"Oxygen is running low...",
	"Return to the surface to refuel it",
	"   ",
	"Look! A person is in the water.",
	"Save them before the sharks get them.",
	"Collect a full crew of people...",
	"then refuel oxygen",
	"Always try to refuel with a full crew",
	"that's how you progess.",
	"Anyways that's everything...",
	"Good luck!",
	" "
]

var current_text_option = 0
var shark_kill_count = 0

var all_controls_pressed = false
var player_refueled = false
var full_crew_refuel = false

var oxygen_zone = preload("res://oxygen_zone.tscn")
var person = preload("res://Person.tscn")

onready var main_text = $MainText
onready var finish_text_timer = $FinishTextTimer

func _ready():
	GameEvent.connect("all_controls_pressed", self, "all_controls_pressed")
	GameEvent.connect("increase_shark_kill_count", self, "shark_kill_count_increase")
	GameEvent.connect("people_refuel", self, "player_oxygen_refuel")
	GameEvent.connect("less_people_refuel", self, "player_oxygen_refuel")
	GameEvent.connect("people_refuel", self, "full_crew_refuel")
	
	main_text.percent_visible = 0

func _process(delta):
	main_text.text = TEXT_OPTIONS[current_text_option]
	
	match current_text_option:
		0: # welcome to the tutorial
			uncover_text()
			update_text_once_previous_completes()
		1: # press some controls
			uncover_text()
			if all_controls_pressed:
				if main_text.percent_visible < 1:
					call_finish_text_timer()
				else:
					if main_text.percent_visible != 0:
						current_text_option += 1
						main_text.percent_visible = 0
		2: # very good
			uncover_text()
			update_text_once_previous_completes()
		3: # sharks incoming
			uncover_text()
			if shark_kill_count == 2:
				if main_text.percent_visible < 1:
					call_finish_text_timer()
				else:
					if main_text.percent_visible != 0:
						current_text_option += 1
						main_text.percent_visible = 0
				shark_kill_count = 0
		4: # great work
			uncover_text()
			update_text_once_previous_completes()
		5: # oxygen running low
			uncover_text()
			update_text_once_previous_completes()
		6: # refuel oxygen
			uncover_text()
			if player_refueled:
				if main_text.percent_visible < 1:
					call_finish_text_timer()
				else:
					if main_text.percent_visible != 0:
						current_text_option += 1
						main_text.percent_visible = 0
		7: # remember to refuel
			uncover_text()
			update_text_once_previous_completes()
		8: # empty space to add time
			uncover_text()
			update_text_once_previous_completes()
		9: # save person
			uncover_text()
			if Global.numb_collected_people >= 1:
				if main_text.percent_visible < 1:
					call_finish_text_timer()
				else:
					if main_text.percent_visible != 0:
						current_text_option += 1
						main_text.percent_visible = 0
		10: # collect full crews of people
			uncover_text()
			if Global.numb_collected_people >= 7:
				if main_text.percent_visible < 1:
					call_finish_text_timer()
				else:
					if main_text.percent_visible != 0:
						current_text_option += 1
						main_text.percent_visible = 0
		11: # refuel oxygen with full crew
			uncover_text()
			if full_crew_refuel:
				if main_text.percent_visible < 1:
					call_finish_text_timer()
				else:
					if main_text.percent_visible != 0:
						current_text_option += 1
						main_text.percent_visible = 0
		12: # Always try to refuel with a full crew
			uncover_text()
			update_text_once_previous_completes()
		13: # that's how you progess.
			uncover_text()
			update_text_once_previous_completes()
		14: # Anyways that's everything...
			uncover_text()
			update_text_once_previous_completes()
		15: # Good luck!
			uncover_text()
			update_text_once_previous_completes()
		16: 
			uncover_text()
			if main_text.percent_visible == 1:
				Global.difficulty = 1
				Global.difficulty_steps = 0
				get_tree().change_scene("res://Prototype.tscn")

func uncover_text():
	main_text.percent_visible = move_toward(main_text.percent_visible, 1, get_process_delta_time() * 0.7)

func update_text_once_previous_completes():
	if main_text.percent_visible == 1:
		call_finish_text_timer()

func call_finish_text_timer():
	if finish_text_timer.time_left == 0: # timer inactive
		finish_text_timer.start() # start timer once

func _on_FinishTextTimer_timeout():
	main_text.percent_visible = 0
	current_text_option += 1
	
	match current_text_option:
		3: # instance shark for tutorial
			GameEvent.emit_signal("instance_tutorial_shark")
			GameEvent.emit_signal("hide_controls")
		5: # show oxygen bar
			rect_position.y = -110
			
			if Global.player != null:
				Global.player.oxygen_level = 25
			
			GameEvent.emit_signal("update_oxygen_ui", 25)
			GameEvent.emit_signal("toggle_oxygen_visiblity", true)
			
			Global.instance_node(oxygen_zone, Vector2(129, 43))
		8:
			GameEvent.emit_signal("spawn_tutorial_people")
			#Global.instance_node(person, Vector2(-30, 85))
		10:
			GameEvent.emit_signal("toggle_crew_visiblity", true)

func all_controls_pressed():
	all_controls_pressed = true

func shark_kill_count_increase():
	shark_kill_count += 1

func player_oxygen_refuel():
	player_refueled = true

func full_crew_refuel():
	full_crew_refuel = true
