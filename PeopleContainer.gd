extends Node

func _ready():
	Global.people_container = self

func _exit_tree():
	Global.people_container = null
