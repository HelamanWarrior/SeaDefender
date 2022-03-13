extends Sprite

var velocity = Vector2(1, 0)

export(int) var speed = 300
export(int) var spread = 7
export(int) var damage = 1

func _ready():
	rotation_degrees = rand_range(-spread, spread)
	velocity = velocity.rotated(rotation)
	flip_h = velocity.x < 0

func _process(delta):
	global_position += velocity * speed * delta
	
	if global_position.x < 0 or global_position.x > 256:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
