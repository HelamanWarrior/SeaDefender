extends Control

onready var current_score = $CurrentScore
onready var high_score = $HighScore
onready var restart_timer = $RestartTimer

func _ready():
	GameEvent.connect("kill_player", self, "player_death")
	visible = false

func player_death():
	current_score.text = "Score " + str(Global.last_play_score)
	high_score.text = "Highscore " + str(Global.highscore)
	visible = true
	restart_timer.start()

func _on_RestartTimer_timeout():
	get_tree().reload_current_scene()
