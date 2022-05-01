extends HBoxContainer

var flash = false

onready var rank_label = $Rank
onready var name_label = $Name
onready var score_label = $Score
onready var animation_player = $AnimationPlayer

func flash():
	animation_player.play("Flash")
	flash = true
