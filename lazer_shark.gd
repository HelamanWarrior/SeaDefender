extends "res://EnemyCore.gd"

var enemy_bullet = preload("res://lazer.tscn")

onready var shoot_point = $ShootPoint
onready var shoot_timer = $ShootTimer

func _ready():
	shoot_timer.wait_time = rand_range(1, 1.5)
	shoot_timer.start()

func _process(delta):
	control_animation()
	
	match current_state:
		states.DEFAULT:
			movement(delta)
			check_death()
		states.HIT:
			pass

func movement(delta):
	update_sprite_facing()
	
	global_position += velocity * speed * delta

func _on_ShootTimer_timeout():
	if current_state == states.DEFAULT:
		SoundManager.play_sound(SoundManager.mini_sub_shoot, rand_range(0.8, 1.2))
		var location = Vector2()
		if !flip_h:
			location = shoot_point.global_position
			var bullet_instance = enemy_bullet.instance()
			add_child(bullet_instance)
			bullet_instance.position = shoot_point.position
		else:
			location = Vector2(global_position.x - abs(shoot_point.position.x), global_position.y)
			var bullet_instance = enemy_bullet.instance()
			add_child(bullet_instance)
			bullet_instance.position = Vector2(-shoot_point.position.x, shoot_point.position.y)
			bullet_instance.scale.x = -1
