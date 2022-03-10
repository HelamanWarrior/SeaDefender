extends Sprite

enum states {DEFAULT, PAUSE}

export(int) var speed = 25

var default_speed = 0
var applied_speed = 0
var points = 30
var invisible = true

var point_value_display = preload("res://PointValueDisplay.tscn")

var current_state = states.DEFAULT

onready var animation_player = $AnimationPlayer

func _ready():
	GameEvent.connect("pause_enemies", self, "pause")
	
	yield(get_tree(), "idle_frame")
	if speed < 0:
		flip_h = true
		
	default_speed = speed
	
	points += 15 * Global.difficulty_steps
	
	update_applied_speed()
	animation_player.playback_speed = applied_speed / default_speed

func _physics_process(delta):
	if current_state == states.DEFAULT:
		update_applied_speed()
		
		global_position.x += applied_speed * delta

func pause(pause):
	if pause:
		current_state = states.PAUSE
	else:
		current_state = states.DEFAULT

func update_applied_speed():
	applied_speed = speed * Global.difficulty

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Player"):
		Global.numb_collected_people += 1
		GameEvent.emit_signal("add_to_score", points)
		
		var points_instance = Global.instance_node(point_value_display, global_position)
		points_instance.value = points
		
		# Collect particles here
		
		queue_free()
		
	if area.is_in_group("EnemyDamager"):
		area.get_parent().queue_free()
		queue_free()
	
	if area.is_in_group("Enemy") and !invisible:
		if round(rand_range(0, 1)) == 0:
			speed = default_speed * 2.2
		else:
			speed = -default_speed * 2.2
		
		if speed > 0:
			flip_h = false
		else:
			flip_h = true
		
		update_applied_speed()
		animation_player.playback_speed = applied_speed / default_speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_InvisiblityTimer_timeout():
	invisible = false
