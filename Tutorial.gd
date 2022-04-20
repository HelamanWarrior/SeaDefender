extends Node2D

func _ready():
	if Global.player != null:
		Global.player.current_state = Global.player.states.TUTORIAL
