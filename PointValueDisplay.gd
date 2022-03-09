extends Node2D

var value = 0
var speed = 15

onready var label = $Label

func _ready():
	label.text = str(value)
	rotation_degrees = rand_range(0, 360)

func _process(delta):
	global_position.y -= speed * delta
	rotation_degrees = lerp(rotation_degrees, 0, 0.3)

func destroy():
	queue_free()
