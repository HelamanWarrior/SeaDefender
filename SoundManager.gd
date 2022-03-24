extends Node

var shark_death = preload("res://SharkDeath.wav")
var player_shoot = preload("res://PlayerShoot.wav")
var player_surface = preload("res://PlayerSurface.wav")
var player_death = preload("res://PlayerDeath.wav")
var mini_sub_hit = preload("res://MiniSubHit.wav")
var mini_sub_destroy = preload("res://MiniSubDestroy.wav")
var mini_sub_shoot = preload("res://MiniSubShoot.wav")
var saving_person = preload("res://SavingPerson.wav")
var points_increase_sound = preload("res://PointsIncreaseSound.wav")
var game_over = preload("res://GameOver.wav")
var music = preload("res://Music.mp3")
var oxygen_alert = preload("res://OxygenAlert.wav")
var oxygen_full_alert = preload("res://FullOxygenAlert.wav")
var person_death = preload("res://PersonDeath.wav")

var sound_script = preload("res://Sound.gd")

onready var music_node = AudioStreamPlayer.new()

func _ready():
	add_child(music_node)
	music_node.stream = music
	music_node.volume_db = -16
	
	if !Global.mute_sounds:
		music_node.play()

func play_sound(sound: AudioStream, pitch: float):
	var audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	
	audio_stream_player.stream = sound
	audio_stream_player.pitch_scale = pitch
	
	audio_stream_player.set_script(sound_script)
	audio_stream_player.connect("finished", audio_stream_player, "finished")
	
	if !Global.mute_sounds:
		audio_stream_player.play()
