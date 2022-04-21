extends Node2D

func _ready():
	if Global.player != null:
		Global.player.current_state = Global.player.states.TUTORIAL
	
	GameEvent.emit_signal("toggle_points_visibility", false)
	GameEvent.emit_signal("toggle_crew_visiblity", false)
	GameEvent.emit_signal("toggle_oxygen_visiblity", false)
