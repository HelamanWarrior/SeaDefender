extends Sprite

enum states {DEFAULT, HIT, PAUSE}
var current_state = states.DEFAULT
var velocity = Vector2(1, 0)

export(int) var speed = 50
export(int) var max_hp = 1
export(int) var points = 25
export(bool) var shark_death_sound = false

var random_offset = rand_range(0, 10)
var destroy = false

var point_value_display = preload("res://PointValueDisplay.tscn")
var pieces = preload("res://SharkPiece.tscn")
export(Texture) var piece_texture = preload("res://SharkPieces.png")

onready var current_hp = max_hp
onready var animation_player = find_node("AnimationPlayer")

func _ready():
	GameEvent.connect("kill_all_enemies", self, "death")
	GameEvent.connect("pause_enemies", self, "pause")
	
	points += 10 * Global.difficulty_steps

func _on_Hitbox_area_entered(area):
	if area.is_in_group("EnemyDamager"):
		take_damage(area.get_parent().damage)
		area.get_parent().queue_free()
	
	if area.is_in_group("Player") and current_state == states.DEFAULT:
		GameEvent.emit_signal("kill_player")

func take_damage(damage: float):
	current_hp -= damage
	current_state = states.HIT
	
	if !shark_death_sound:
		SoundManager.play_sound(SoundManager.mini_sub_hit, rand_range(0.8, 1.2))
	
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
	GameEvent.emit_signal("increase_shark_kill_count")
	
	if shark_death_sound:
		SoundManager.play_sound(SoundManager.shark_death, rand_range(0.8, 1.2))
	else:
		SoundManager.play_sound(SoundManager.mini_sub_destroy, rand_range(0.8, 1.2))
	
	var points_instance = Global.instance_node(point_value_display, global_position)
	points_instance.value = points
	
	#if blood != null:
	#	Global.instance_node(blood, global_position)
	
	if pieces != null:
		for i in range(2):
			var piece_instance = Global.instance_node(pieces, global_position)
			piece_instance.frame = i
			piece_instance.current_texture = piece_texture
	
	OS.delay_msec(Global.freeze_ms)
	
	destroy = true
	queue_free()

func control_animation():
	scale = lerp(scale, Vector2.ONE, 0.1)
	rotation_degrees = lerp(rotation_degrees, 0, 0.1)

func pause(pause):
	if pause:
		current_state = states.PAUSE
	else:
		current_state = states.DEFAULT

func update_sprite_facing():
	flip_h = velocity.x < 0

func _on_VisibilityNotifier2D_screen_exited():
	if !destroy:
		GameEvent.emit_signal("increase_shark_kill_count")
		queue_free()
		destroy = true
