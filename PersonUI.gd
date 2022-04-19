extends Sprite

var play_animation = true

onready var animation_player = $AnimationPlayer

func _ready():
	GameEvent.connect("update_person_count", self, "update_person_count")
	GameEvent.connect("destroy_crew_ui", self, "play_destroy")
	
	update_person_count()
	
	yield(get_tree(), "idle_frame")
	
	if play_animation:
		animation_player.play("Drop")
	else:
		animation_player.play("Drop")
		animation_player.seek(0.1)

func update_person_count():
	if Global.numb_collected_people >= 7:
		frame = 1
	else:
		frame = 0

func play_destroy():
	animation_player.play("Destroy")

func destroy():
	queue_free()
