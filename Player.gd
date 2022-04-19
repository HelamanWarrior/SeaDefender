extends Sprite

enum states {DEFAULT, REFUEL, PEOPLE_REFUEL}

var current_state = states.DEFAULT

var speed = Vector2(125, 90)
var acc = 400
var rotation_strength = 15

var movement_input = Vector2()
var velocity = Vector2()
var is_shooting = false
var can_shoot = true
var death_on_refuel = false
var full_crew = false

var oxygen_level = 100
var points = 0

var bullet = preload("res://PlayerBullet.tscn")
var flash_texture = preload("res://PlayerFlash.png")
var player_pieces_texture = preload("res://PlayerPieces.png")
var pieces = preload("res://SharkPiece.tscn")
var shoot_particle = preload("res://PlayerShootParticle.tscn")

onready var default_texture = texture
onready var texture_size = Vector2(texture.get_width() / hframes, texture.get_height())
onready var texture_size_half = texture_size * 0.5
onready var shoot_point = $ShootPoint
onready var reload_timer = $ReloadTimer
onready var decrease_people_timer = $DecreasePeopleTimer

func _ready():
	Global.player = self
	
	GameEvent.connect("oxygen_refuel", self, "oxygen_refuel_state_change")
	GameEvent.connect("add_to_score", self, "add_to_score")
	GameEvent.connect("people_refuel", self, "people_refuel")
	GameEvent.connect("less_people_refuel", self, "less_people_refuel")
	GameEvent.connect("kill_player", self, "death")
	GameEvent.connect("full_crew", self, "full_crew")

func _physics_process(delta) -> void:
	clamp_position()
	
	match current_state:
		states.DEFAULT:
			movement(delta)
			control_shooting()
			lose_oxygen(delta)
			
			if oxygen_level <= 0:
				GameEvent.emit_signal("kill_player")
		states.REFUEL:
			move_to_refuel()
			reset_animation()
			oxygen_refuel()
		states.PEOPLE_REFUEL:
			move_to_refuel()
			reset_animation()
			people_refuel()

func movement(delta) -> void:
	control_animation()
	rotate_to_input_movement()
	
	if !is_shooting:
		flip_direction_to_movement()
	
	movement_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement_input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	movement_input = movement_input.normalized()
	
	velocity = lerp(velocity, movement_input * speed * Global.difficulty, 0.25)
	
	global_position += velocity * delta

func control_shooting():
	if Input.is_action_pressed("action"):
		is_shooting = true
		
		if can_shoot:
			SoundManager.play_sound(SoundManager.player_shoot, rand_range(0.8, 1.2))
			
			for _i in range(4):
				var location = shoot_point.global_position
				
				if !is_facing_right():
					location.x = -abs(shoot_point.position.x) + global_position.x
				
				Global.instance_node(shoot_particle, location)
			
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
	
	var min_position_y = 30 + texture_size_half.y
	var max_position_y = 205 - texture_size_half.y
	
	var target_position := Vector2.ZERO
	target_position.x = clamp(global_position.x, min_position_x, max_position_x)
	target_position.y = clamp(global_position.y, min_position_y, max_position_y)
	
	global_position = lerp(global_position, target_position, 0.5)
	global_position.x = clamp(global_position.x, min_position_x - 5, max_position_x + 5)
	global_position.y = clamp(global_position.y, min_position_y - 5, max_position_y + 5)

func flip_direction_to_movement():
	if movement_input.x > 0:
		if flip_h: #Player just turned
			scale = Vector2(0.6, 1.4)
			
		flip_h = false
	elif movement_input.x < 0:
		if !flip_h: #Player just turned
			scale = Vector2(0.6, 1.4)
		
		flip_h = true

func oxygen_refuel():
	current_state = states.REFUEL
	oxygen_level = move_toward(oxygen_level, 100, 0.8)
	GameEvent.emit_signal("update_oxygen_ui", oxygen_level)
	
	if oxygen_level > 99:
		GameEvent.emit_signal("pause_enemies", false)
		Global.difficulty *= 1.1
		SoundManager.play_sound(SoundManager.oxygen_full_alert, rand_range(0.8, 1.2))
		
		if death_on_refuel:
			GameEvent.emit_signal("kill_player")
		
		texture = default_texture
		current_state = states.DEFAULT

func control_animation():
	scale = lerp(scale, Vector2.ONE, 0.1)

func _on_ReloadTimer_timeout():
	can_shoot = true

func lose_oxygen(delta):
	oxygen_level -= delta * 2.5
	GameEvent.emit_signal("update_oxygen_ui", oxygen_level)

func move_to_refuel():
	global_position.y = lerp(global_position.y, 35, 0.1)

func reset_animation():
	rotation_degrees = lerp(rotation_degrees, 0, 0.1)
	scale = lerp(scale, Vector2.ONE, 0.1)

func people_refuel():
	current_state = states.PEOPLE_REFUEL
	texture = flash_texture
	
	if oxygen_level >= 75:
		death_on_refuel = true
	
	if decrease_people_timer.time_left == 0:
		# Point award on enemies is only increased if the player refuels with all the people
		if Global.numb_collected_people >= 7:
			Global.difficulty_steps += 1
			SoundManager.play_sound(SoundManager.points_increase_sound, rand_range(0.8, 1.2))
		
		decrease_people_timer.start()
		GameEvent.emit_signal("pause_enemies", true)
			
		if Global.numb_collected_people <= 0:
			GameEvent.emit_signal("kill_all_enemies")
			oxygen_refuel()

func less_people_refuel():
	current_state = states.PEOPLE_REFUEL
	texture = flash_texture
	
	if oxygen_level >= 75:
		death_on_refuel = true
	
	Global.numb_collected_people -= 1
	GameEvent.emit_signal("pause_enemies", true)
	oxygen_refuel()

func add_to_score(amount):
	points += amount

func _on_DecreasePeopleTimer_timeout():
	if Global.numb_collected_people > 0:
		Global.numb_collected_people -= 1

func death():
	GameEvent.emit_signal("pause_enemies", true)
	
	Global.last_play_score = points
	Global.numb_collected_people = 0
	
	SoundManager.play_sound(SoundManager.player_death, rand_range(0.8, 1.2))
	SoundManager.play_sound(SoundManager.game_over, rand_range(0.8, 1.2))
	
	if points > Global.highscore:
		Global.highscore = points
	
	#modulate = Color(1, 1, 1, 0)
	
	for i in range(10):
		var piece_instance = Global.instance_node(pieces, global_position)
		piece_instance.current_texture = player_pieces_texture
		piece_instance.hframes = 10
		piece_instance.frame = i
		piece_instance.animation_speed = 0.5
		piece_instance.move_speed = rand_range(75, 200)
		piece_instance.lerp_speed = rand_range(0.05, 0.1)
	
	queue_free()
	
	#OS.delay_msec(250)
	#get_tree().reload_current_scene()

func full_crew():
	full_crew = true

func _exit_tree():
	Global.player = null
