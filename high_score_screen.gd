extends Control

const POSSIBLE_LETTERS = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

var current_letter_box_focus = 1

onready var letter_select_boxes = [$HBoxContainer/LetterSelectBox1, $HBoxContainer/LetterSelectBox2, $HBoxContainer/LetterSelectBox3]

func _ready():
	for letter_box in letter_select_boxes:
		letter_box.connect("focus_entered", self, "letter_focus_entered_" + str(int(letter_box.name)))
	
	letter_select_boxes[0].grab_focus()

func _input(_event):
	if Input.is_action_just_pressed("down"):
		cycle_letters(1)
	elif Input.is_action_pressed("up"):
		cycle_letters(-1)

func cycle_letters(cycle_speed):
	var current_letter_box = letter_select_boxes[current_letter_box_focus - 1]
	var current_letter = current_letter_box.selected_letter_label.text
	var next_letter_index = POSSIBLE_LETTERS.find(current_letter) + cycle_speed
	
	if next_letter_index > POSSIBLE_LETTERS.size() - 1:
		next_letter_index = 0
	elif next_letter_index < 0:
		next_letter_index = POSSIBLE_LETTERS.size() - 1
		
	current_letter_box.selected_letter_label.text = POSSIBLE_LETTERS[next_letter_index]

func letter_focus_entered_1():
	current_letter_box_focus = 1

func letter_focus_entered_2():
	current_letter_box_focus = 2

func letter_focus_entered_3():
	current_letter_box_focus = 3
