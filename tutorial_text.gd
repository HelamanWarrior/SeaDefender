extends Control

const TEXT_OPTIONS = [
	"Welcome to the Tutorial", 
	"Start by using the controls above", 
	"Awesome!", 
	"Sharks incoming! you know what to do.", 
	"Great Work!",
	"Oxygen is running low...",
	"Return to the surface to refuel it"
]

var current_text_option = 0
var shark_kill_count = 0

var all_controls_pressed = false

onready var main_text = $MainText
onready var finish_text_timer = $FinishTextTimer

func _ready():
	GameEvent.connect("all_controls_pressed", self, "all_controls_pressed")
	GameEvent.connect("increase_shark_kill_count", self, "increase_shark_kill_count")
	
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
			
			GameEvent.emit_signal("update_oxygen_ui", 25)
			GameEvent.emit_signal("toggle_oxygen_visiblity", true)

func all_controls_pressed():
	all_controls_pressed = true

func increase_shark_kill_count():
	shark_kill_count += 1