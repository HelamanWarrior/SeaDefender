extends Label

var current_score = 0

func _ready():
	GameEvent.connect("add_to_score", self, "update_score")
	
	text = str(current_score)

func update_score(amount):
	current_score += amount
	text = str(current_score)
