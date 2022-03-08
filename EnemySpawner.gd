extends Node2D

var can_spawn = true
var current_spawned_points = []
var current_enemy = null

var shark = preload("res://Shark.tscn")
var person = preload("res://Person.tscn")

onready var spawn_person_timer = $SpawnPersonTime
onready var left_node = $Left
onready var right_node = $Right

func _ready():
	GameEvent.connect("pause_enemies", self, "pause_enemies")
	
	spawn_person_timer.wait_time = rand_range(2, 5)
	spawn_person_timer.start()

func _on_SpawnTime_timeout():
	current_spawned_points = []
	current_enemy = shark
	
	if can_spawn:
		var rand = round(rand_range(0, 4))
		print("AA")
		if rand == 0: #Right
			spawn_enemy_algo(left_node)
		elif rand == 1: #Left
			spawn_enemy_algo(right_node)
		else:
			spawn_enemy_algo(left_node)
			spawn_enemy_algo(right_node)

func spawn_enemy_algo(direction_node):
	var node_numb = round(rand_range(1, 4))
	
	for i in range(round(rand_range(1, 4))):
		change_enemy_random()
		
		if current_spawned_points.size() < 4:
			while current_spawned_points.find(node_numb) != -1:
				node_numb = round(rand_range(1, 4))
		else:
			return
		
		var location = direction_node.get_node(str(node_numb)).global_position
		var node_instance = Global.instance_node(current_enemy, location)
		
		if direction_node == right_node:
			node_instance.velocity.x = -1
		
		current_spawned_points.append(node_numb)

func change_enemy_random():
	if Global.difficulty > 1.2:
		if round(rand_range(1, 3)) == 1:
			#current_enemy = mini_sub
			pass

func _on_SpawnPersonTime_timeout():
	if Global.numb_collected_people < 7 and is_instance_valid(Global.people_container) and can_spawn:
		var people_for_full = 7 - Global.numb_collected_people
		if Global.people_container.get_child_count() < people_for_full:
			_spawn_person()
	
	spawn_person_timer.wait_time = rand_range(2, 5)
	spawn_person_timer.start()

func _spawn_person():
	var node_numb = round(rand_range(1, 4))
	
	if round(rand_range(0, 1)) == 0:
		var location = left_node.get_node(str(node_numb)).global_position
		
		if is_instance_valid(Global.people_container):
			var person_instance = person.instance()
			Global.people_container.add_child(person_instance)
			person_instance.global_position = location
	else:
		var location = right_node.get_node(str(node_numb)).global_position
		
		if is_instance_valid(Global.people_container):
			var person_instance = person.instance()
			Global.people_container.add_child(person_instance)
			person_instance.global_position = location
			person_instance.speed = -person_instance.speed
		
		spawn_person_timer.wait_time = rand_range(0, 10)
		spawn_person_timer.start()

func pause_enemies(pause):
	can_spawn = !pause
