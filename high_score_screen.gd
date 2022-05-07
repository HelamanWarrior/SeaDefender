extends Control

const POSSIBLE_LETTERS = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', " "]

var current_letter_box_focus = 1
var player_input_text = ["a", "a", "a"]
var fill_out_high_scores = false

signal updated_text(text)

var game_over_allow_restart = false

onready var letter_select_boxes = [$TextInputField/LetterSelectBox1, $TextInputField/LetterSelectBox2, $TextInputField/LetterSelectBox3]
onready var score_container = $ScoreContainer
onready var finish_button = $TextInputField/FinishButton

onready var text_input_field = $TextInputField
onready var game_over = $GameOver
onready var game_over_score_text = $GameOver/ScoreText
onready var game_over_high_score_text = $GameOver/HighScoreText
onready var restart_timer = $RestartTimer

func _ready():
	connect("updated_text", score_container, "_updated_text")
	finish_button.connect("focus_entered", self, "_finish_button_focused")
	finish_button.connect("pressed", self, "_finish_button_pressed")
	
	for letter_box in letter_select_boxes:
		letter_box.connect("focus_entered", self, "letter_focus_entered_" + str(int(letter_box.name)))
	
	for score in Global.score_data:
		if Global.last_play_score > score[2]:
			fill_out_high_scores = true
			break
	
	# update the score value on the corresponding row the player's score will go on
	score_container.update_current_scoreboard_values()
	
	if !fill_out_high_scores:
		game_over_score_text.text = "Score " + str(Global.last_play_score)
		game_over_high_score_text.text = "Highscore " + str(Global.highscore)
		score_container.game_over = true
		
		restart_timer.start()
		text_input_field.hide()
		game_over.show()
	else:
		letter_select_boxes[0].grab_focus()
		emit_signal("updated_text", "aaa") # reset current text

func _input(_event):
	if current_letter_box_focus != 0 and fill_out_high_scores:
		if Input.is_action_just_pressed("down"):
			cycle_letters(1)
		elif Input.is_action_just_pressed("up"):
			cycle_letters(-1)

func cycle_letters(cycle_speed):
	var current_letter_box = letter_select_boxes[current_letter_box_focus - 1]
	var current_letter = current_letter_box.selected_letter_label.text
	var next_letter_index = POSSIBLE_LETTERS.find(current_letter) + cycle_speed
	
	# wrap around array if letter exceeds the length
	if next_letter_index > POSSIBLE_LETTERS.size() - 1:
		next_letter_index = 0
	elif next_letter_index < 0:
		next_letter_index = POSSIBLE_LETTERS.size() - 1
	
	current_letter_box.selected_letter_label.text = POSSIBLE_LETTERS[next_letter_index]
	
	player_input_text[current_letter_box_focus - 1] = POSSIBLE_LETTERS[next_letter_index]
	var combined_text_entry = player_input_text[0] + player_input_text[1] + player_input_text[2]
	emit_signal("updated_text", combined_text_entry)

func letter_focus_entered_1():
	current_letter_box_focus = 1

func letter_focus_entered_2():
	current_letter_box_focus = 2

func letter_focus_entered_3():
	current_letter_box_focus = 3

func _finish_button_focused():
	current_letter_box_focus = 0

func _finish_button_pressed():
	# time to right out the high score value
	for i in range(score_container.get_children().size() - 1):
		var score_node = score_container.get_children()[i]
		# skip index zero that's just ranking which never changes
		Global.score_data[i][1] = score_node.name_label.text # index 1 is name
		Global.score_data[i][2] = int(score_node.score_label.text) # index 2 is the score
		
	# switch back to the main game
	print(Global.score_data)
	Global.difficulty = 1
	Global.difficulty_steps = 0
	get_tree().change_scene("res://Prototype.tscn")

func _process(_delta):
	if game_over_allow_restart and Input.is_action_just_released("action"):
		Global.difficulty = 1
		Global.difficulty_steps = 0
		get_tree().change_scene("res://Prototype.tscn")

func _on_RestartTimer_timeout():
	game_over_allow_restart = true
