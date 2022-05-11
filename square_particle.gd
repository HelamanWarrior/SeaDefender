extends Sprite

var scale_target = 1

onready var tween = $Tween
onready var actual_destroy_timer = $ActualDestroyTimer

func _init():
	scale = Vector2(0, 0)
	rotation_degrees = rand_range(0, 360)

func _ready():
	tween.interpolate_property(self, "scale", scale, Vector2(scale_target, scale_target), 0.1, Tween.TRANS_CUBIC)
	tween.start()
	
func _on_DestroyTimer_timeout():
	tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.15, Tween.TRANS_CUBIC)
	tween.start()
	actual_destroy_timer.start()

func _on_ActualDestroyTimer_timeout():
	queue_free()
