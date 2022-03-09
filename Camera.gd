extends Camera2D

var y_input = 0

onready var target_location = global_position

func _physics_process(delta):
	if is_instance_valid(Global.player):
		global_position = lerp(global_position, target_location, 0.15)
		global_position.y = clamp(global_position.y, 70, 145)
		
		var y_input_target = Input.get_action_strength("down") - Input.get_action_strength("up")
		y_input = lerp(y_input, y_input_target, 0.025)
		
		target_location.y = Global.player.global_position.y + (y_input * 30)
