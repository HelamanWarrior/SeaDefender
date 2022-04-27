extends Control

var level = 1

onready var current_level_label = $Pivot/CurrentLevel
onready var animation_player = $Pivot/AnimationPlayer

func _ready():
	GameEvent.connect("increase_level", self, "_increase_level")
	animation_player.play("Appear")

func _increase_level():
	level += 1
	current_level_label.text = "Level " + str(level)
	animation_player.play("Appear")
