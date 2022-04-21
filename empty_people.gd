extends Node2D

func _ready():
	GameEvent.connect("toggle_crew_visiblity", self, "toggle_visiblity")

func toggle_visiblity(is_visible):
	visible = is_visible
