extends Control

var allow_restart = false
var fade = false

onready var current_score = $CurrentScore
onready var high_score = $HighScore
onready var restart_timer = $RestartTimer
onready var fade_timer = $FadeTimer

func _ready():
	GameEvent.connect("kill_player", self, "player_death")
	visible = false
	modulate.a = 0

func _process(_delta):
	if fade:
		modulate.a = lerp(modulate.a, 1, 0.1)
	
	if allow_restart and Input.is_action_just_released("action"):
		Global.difficulty = 1
		Global.difficulty_steps = 0
		get_tree().reload_current_scene()

func player_death():
	current_score.text = "Score " + str(Global.last_play_score)
	high_score.text = "Highscore " + str(Global.highscore)
	visible = true
	fade_timer.start()

func _on_RestartTimer_timeout():
	allow_restart = true

func _on_FadeTimer_timeout():
	fade = true
	get_tree().change_scene("res://high_score_screen.tscn")
	restart_timer.start()
