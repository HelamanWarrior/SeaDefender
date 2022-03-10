extends Sprite

var rotation_velocity = (randi() % 2) * 2 - 1
var rotation_speed = 50
var velocity = Vector2(1, 0)
var move_speed = 150
var lerp_speed = 0.1

var current_texture = null
var animation_speed = 1

onready var animation_player = $AnimationPlayer

func _init():
	velocity = velocity.rotated(deg2rad(rand_range(0, 360)))

func _ready():
	yield(get_tree(), "idle_frame")
	
	if texture != null:
		texture = current_texture
	
	if animation_speed != 1:
		animation_player.playback_speed = animation_speed

func _process(delta):
	rotation_degrees += rotation_speed * rotation_velocity * delta
	global_position += velocity * move_speed * delta
	
	move_speed = lerp(move_speed, 0, lerp_speed)

func destroy():
	queue_free()
