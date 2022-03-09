extends Sprite

enum states {DEFAULT, HIT, PAUSE}
var current_state = states.DEFAULT
var velocity = Vector2(1, 0)

export(int) var speed = 50
export(int) var max_hp = 1
export(int) var points = 25

var current_hp = max_hp
var random_offset = rand_range(0, 10)

var point_value_display = preload("res://PointValueDisplay.tscn")

onready var animation_player = find_node("AnimationPlayer")

func _ready():
	GameEvent.connect("kill_all_enemies", self, "death")
	GameEvent.connect("pause_enemies", self, "pause")
	
	points += 10 * Global.difficulty_steps

func _on_Hitbox_area_entered(area):
	if area.is_in_group("EnemyDamager"):
		_take_damage(area.get_parent().damage)
		area.get_parent().queue_free()
	
	if area.is_in_group("player") and current_state == states.DEFAULT:
		GameEvent.emit_signal("kill_player")

func _take_damage(damage: float):
	current_hp -= damage
	current_state = states.HIT
	
	animation_player.play("hit")
	scale = Vector2(1.3, 1.3)
	
	rotation_degrees = 15 * int(!flip_h)

func reset_hit():
	animation_player.play("idle")
	current_state = states.DEFAULT

func check_death():
	if current_hp <= 0:
		death()

func death():
	GameEvent.emit_signal("camera_shake", 0.4)
	GameEvent.emit_signal("add_to_score", points)
	
	#SoundManager.play_sound(SoundManager.shark_death, rand_range(0.8, 1.2))
	
	var points_instance = Global.instance_node(point_value_display, global_position)
	points_instance.value = points
	
	#if blood != null:
	#	Global.instance_node(blood, global_position)
	
	#if pieces != null:
	#	for i in range(2):
	#		var piece_instance = Global.instance_node(pieces, global_position)
	#		piece_instance.frame = i
	
	OS.delay_msec(Global.freeze_ms)
	
	queue_free()

func control_animation():
	scale = lerp(scale, Vector2.ONE, 0.1)
	rotation_degrees = lerp(rotation_degrees, 0, 0.1)

func pause(pause):
	if pause:
		current_state = states.PAUSE
	else:
		current_state = states.DEFAULT

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
