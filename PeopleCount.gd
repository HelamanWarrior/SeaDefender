extends Node2D

var person_ui = preload("res://PersonUI.tscn")

var current_person_offset: int = 0

func _ready():
	GameEvent.connect("update_person_count", self, "update_ui")

func update_ui():
	if get_child_count() < Global.numb_collected_people:
		instance_person()
		
		current_person_offset += 12
	else:
		# basically only emit the destroy crew signal once
		if current_person_offset != 0: # very hacky but okay
			GameEvent.emit_signal("destroy_crew_ui")
		
		current_person_offset = 0
		
		if Global.numb_collected_people > 0:
			for i in range(Global.numb_collected_people):
				var person_instance = instance_person()
				person_instance.play_animation = false
				current_person_offset += 12

func instance_person():
	var person_ui_instance = person_ui.instance()
	add_child(person_ui_instance)
	person_ui_instance.global_position = global_position + Vector2(current_person_offset, 0)
	return person_ui_instance
