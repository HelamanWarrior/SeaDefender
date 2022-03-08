extends "res://EnemyCore.gd"

func _physics_process(_delta):
	control_animation()
	
	match current_state:
		states.DEFAULT:
			check_death()
		states.HIT:
			pass
