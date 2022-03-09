extends Node2D

func _ready():
	GameEvent.connect("update_oxygen_ui", self, "update_oxygen_ui")
	
func update_oxygen_ui(oxygen_amount):
	var amount = round(oxygen_amount)
	
	# Add flashing states here
	
