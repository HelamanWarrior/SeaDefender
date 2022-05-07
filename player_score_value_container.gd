extends HBoxContainer

var flash = false

onready var rank_label = $Rank
onready var name_label = $Name
onready var score_label = $Score
onready var animation_player = $AnimationPlayer

func _ready():
	match int(name):
		1:
			rank_label.text = "1st"
		2:
			rank_label.text = "2nd"
		3:
			rank_label.text = "3rd"
		4:
			rank_label.text = "4th"
		5:
			rank_label.text = "5th"

func flash():
	animation_player.play("Flash")
	flash = true

func update_text(text_input):
	name_label.text = text_input
