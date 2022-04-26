extends Node

var person = preload("res://Person.tscn")

onready var spawn_time = $SpawnTime
onready var spawn_1 = $Spawn1
onready var spawn_2 = $Spawn2

func _ready():
	GameEvent.connect("spawn_tutorial_people", self, "_spawn_tutorial_people")

func _spawn_tutorial_people():
	spawn_person_at_rand_point() # immediately spawn person
	spawn_time.start()

func _on_SpawnTime_timeout():
	if Global.numb_collected_people < 7: # don't spawn people if player has full crew
		spawn_person_at_rand_point()
	else: # deactivate person spawning system if player has full crew
		spawn_time.stop()

func spawn_person_at_rand_point():
	var current_spawner = $Spawn1
	if round(rand_range(1, 2)) == 2:
		current_spawner = $Spawn2
		
	var person_instance = Global.instance_node(person, current_spawner.global_position)
	if current_spawner == $Spawn2:
		person_instance.speed = -person_instance.speed
