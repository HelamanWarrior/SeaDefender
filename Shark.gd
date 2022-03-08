extends "res://EnemyCore.gd"

func _physics_process(delta):
	control_animation()
	
	match current_state:
		states.DEFAULT:
			check_death()
			movement(delta)
		states.HIT:
			pass

func movement(delta):
	update_sprite_facing()
	
	velocity.y = sin(global_position.x * 0.15 + random_offset) * 0.5
	global_position += velocity * speed * delta

func update_sprite_facing():
	flip_h = velocity.x < 0
