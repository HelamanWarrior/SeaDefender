extends Node2D

func _ready():
	GameEvent.connect("add_to_score", self, "update_score")

func _process(_delta):
	scale = lerp(scale, Vector2(1, 1), 0.25)
	rotation_degrees = lerp(rotation_degrees, 0, 0.2)

func update_score(amount):
	scale.x = 1.4
	scale.y = scale.x
	
	rotation_degrees = rand_range(-25, 25)
