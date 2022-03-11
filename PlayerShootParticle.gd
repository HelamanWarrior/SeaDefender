extends Sprite

var velocity = Vector2(1, 0)
var speed = 100

func _init():
	rotation_degrees = rand_range(0, 360)
	velocity = velocity.rotated(deg2rad(rotation_degrees))

func _process(delta):
	global_position += velocity * speed * delta

func _destroy():
	queue_free()
