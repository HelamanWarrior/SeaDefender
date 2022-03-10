extends Sprite

var velocity = Vector2(1, 0)

export(int) var speed = 250
export(int) var spread = 7
export(int) var damage = 1

func _ready():
	rotation_degrees = rand_range(-spread, spread)
	velocity = velocity.rotated(rotation)
	
	if velocity.x < 0:
		flip_h = true

func _process(delta):
	global_position += velocity * speed * delta

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Player"):
		GameEvent.emit_signal("kill_player")
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
