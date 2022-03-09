extends Area2D

func _on_OxygenZone_area_entered(area):
	if area.is_in_group("Player"):
		if Global.numb_collected_people >= 7:
			print("people refuel")
			GameEvent.emit_signal("people_refuel")
		else:
			print("less people refuel")
			GameEvent.emit_signal("less_people_refuel")
