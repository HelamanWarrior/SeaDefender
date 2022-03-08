extends Sprite

var speed = Vector2(125, 90)
var acc = 400
var rotation_strength = 15

var movement_input = Vector2()
var velocity = Vector2()
var is_shooting = false
var can_shoot = true

var bullet = preload("res://PlayerBullet.tscn")

onready var texture_size = Vector2(texture.get_width() / hframes, texture.get_height())
onready var texture_size_half = texture_size * 0.5
onready var shoot_point = $ShootPoint
onready var reload_timer = $ReloadTimer

func _physics_process(_delta) -> void:
	movement()
	rotate_to_input_movement()
	clamp_position()
	control_shooting()

func movement() -> void:
	var delta = get_physics_process_delta_time()
	control_animation()
	
	if !is_shooting:
		flip_direction_to_movement()
	
	movement_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement_input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	movement_input = movement_input.normalized()
	
	# TODO: Multiply speed with Global difficulty
	velocity = lerp(velocity, movement_input * speed, 0.25)
	
	global_position += velocity * delta

func control_shooting():
	if Input.is_action_pressed("action"):
		is_shooting = true
		
		if can_shoot:
			#SoundManager.play_sound(SoundManager.player_shoot, rand_range(0.8, 1.2))
			
			for _i in range(4):
				var location = shoot_point.global_position
				
				if !is_facing_right():
					location.x = -abs(shoot_point.position.x) + global_position.x
				
				#Global.instance_node(shoot_particle, location)
			
			is_shooting = true
			
			var target_position = shoot_point.position
			
			if !is_facing_right():
				target_position.x = -abs(shoot_point.position.x)
			
			var bullet_instance = Global.instance_node(bullet, target_position + global_position)
			
			if !is_facing_right():
				bullet_instance.velocity.x = -1
			
			scale = Vector2(0.7, 1.3)
			
			reload_timer.start()
			can_shoot = false
	else:
		is_shooting = false

func rotate_to_input_movement():
	var rotation_target: float = 0
	
	if movement_input.y == 0:
		rotation_target = movement_input.x * rotation_strength
	else:
		if is_facing_right():
			rotation_target = movement_input.y * rotation_strength
		else:
			rotation_target = -movement_input.y * rotation_strength
	
	rotation_degrees = lerp(rotation_degrees, rotation_target, 0.25)

func is_facing_right():
	return !flip_h

func clamp_position():
	var min_position_x = texture_size_half.x
	var max_position_x = Global.game_size.x - texture_size_half.x
	
	var min_position_y = 35 + texture_size_half.y
	var max_position_y = 205 - texture_size_half.y
	
	var target_position := Vector2.ZERO
	target_position.x = clamp(global_position.x, min_position_x, max_position_x)
	target_position.y = clamp(global_position.y, min_position_y, max_position_y)
	
	global_position = lerp(global_position, target_position, 0.3)

func flip_direction_to_movement():
	if movement_input.x > 0:
		if flip_h: #Player just turned
			scale = Vector2(0.6, 1.4)
		
		flip_h = false
	elif movement_input.x < 0:
		if !flip_h: #Player just turned
			scale = Vector2(0.6, 1.4)
		
		flip_h = true

func control_animation():
	scale = lerp(scale, Vector2.ONE, 0.1)

func _on_ReloadTimer_timeout():
	can_shoot = true
