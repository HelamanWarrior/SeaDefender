extends Sprite

var target_location = Vector2(0, 0)
var target_rotation = 0
var destroy = false

onready var raycast = $RayCast2D
onready var start = $Start
onready var update_start = $UpdateStart

func _process(delta):
	start.rotation_degrees = lerp(start.rotation_degrees, target_rotation, 0.3)
	start.position = lerp(start.position, target_location, 0.3)
	
	if destroy:
		scale.y = lerp(scale.y, 0, 0.2)
		if scale.y < 0.05:
			queue_free()

func _on_UpdateStart_timeout():
	target_rotation = rand_range(0, 360)
	target_location.x = rand_range(-1, 1)
	target_location.y = rand_range(-1, 1)
	
	update_start.wait_time = rand_range(0.025, 0.1)
	update_start.start()

func _on_DestroyTimer_timeout():
	destroy = true
