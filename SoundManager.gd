extends Node

var shark_death = preload("res://SharkDeath.wav")
var player_shoot = preload("res://PlayerShoot.wav")
var player_surface = preload("res://PlayerSurface.wav")
var mini_sub_hit = preload("res://MiniSubHit.wav")
var mini_sub_destroy = preload("res://MiniSubDestroy.wav")
var mini_sub_shoot = preload("res://MiniSubShoot.wav")

var sound_script = preload("res://Sound.gd")

func play_sound(sound: AudioStream, pitch: float):
	var audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	
	audio_stream_player.stream = sound
	audio_stream_player.pitch_scale = pitch
	
	audio_stream_player.set_script(sound_script)
	audio_stream_player.connect("finished", audio_stream_player, "finished")
	
	audio_stream_player.play()
