extends Area2D

func _on_OxygenZone_area_entered(area):
	if area.is_in_group("Player"):
		if Global.numb_collected_people >= 7:
			GameEvent.emit_signal("people_refuel")
		else:
			GameEvent.emit_signal("less_people_refuel")
