extends Sprite

func _ready():
	GameEvent.connect("update_person_count", self, "update_person_count")

func update_person_count():
	if Global.numb_collected_people >= 7:
		frame = 1
	else:
		frame = 0
