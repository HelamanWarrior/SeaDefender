extends "res://EnemyCore.gd"

var enemy_bullet = preload("res://lazer.tscn")
var square_particle = preload("res://square_particle.tscn")

var instanced_square_particle = [false, false, false, false, false]

onready var shoot_point = $ShootPoint
onready var shoot_timer = $ShootTimer

func _ready():
	shoot_timer.wait_time = rand_range(1.5, 2)
	shoot_timer.start()

func _process(delta):
	control_animation()
	if shoot_timer.time_left < 0.25:
		if !instanced_square_particle[4]:
			var particle = instance_square_particle()
			particle.scale_target = 1.5 
			instanced_square_particle[4] = true
	elif shoot_timer.time_left < 0.5:
		if !instanced_square_particle[3]:
			var particle = instance_square_particle()
			particle.scale_target = 1.25
			instanced_square_particle[3] = true
	elif shoot_timer.time_left < 1:
		if !instanced_square_particle[2]:
			instance_square_particle()
			instanced_square_particle[2] = true
	elif shoot_timer.time_left < 1.5:
		if !instanced_square_particle[1]:
			instance_square_particle()
			instanced_square_particle[1] = true
	
	match current_state:
		states.DEFAULT:
			movement(delta)
			check_death()
		states.HIT:
			pass

func instance_square_particle():
	var location = shoot_point.position
	if flip_h:
		location = Vector2(-21, 1) + global_position
	else:
		location = Vector2(21, 1) + global_position
	
	return Global.instance_node(square_particle, location)

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
