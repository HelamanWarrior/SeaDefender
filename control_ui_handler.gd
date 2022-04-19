extends Node2D

onready var wasd_key_container = $wasd_keys
onready var arrow_key_container = $arrow_keys
onready var generic_key_container = $generic_key

onready var a_key = $wasd_keys/a_key
onready var s_key = $wasd_keys/s_key
onready var d_key = $wasd_keys/d_key
onready var w_key = $wasd_keys/w_key

onready var left_key = $arrow_keys/left_key
onready var down_key = $arrow_keys/down_key
onready var right_key = $arrow_keys/right_key
onready var up_key = $arrow_keys/up_key

onready var space_key = $generic_key/space_key

func _input(event):
	animate_key_press(a_key, KEY_A, wasd_key_container)
	animate_key_press(s_key, KEY_S, wasd_key_container)
	animate_key_press(d_key, KEY_D, wasd_key_container)
	animate_key_press(w_key, KEY_W, wasd_key_container)
	
	animate_key_press(left_key, KEY_LEFT, arrow_key_container)
	animate_key_press(down_key, KEY_DOWN, arrow_key_container)
	animate_key_press(right_key, KEY_RIGHT, arrow_key_container)
	animate_key_press(up_key, KEY_UP, arrow_key_container)
	
	animate_key_press(space_key, KEY_SPACE, generic_key_container)

func animate_key_press(key_node, scancode, container):
	if Input.is_key_pressed(scancode):
		if !container.visible:
			container.visible = true
			
			if container == wasd_key_container:
				arrow_key_container.visible = false
			elif container == arrow_key_container:
				wasd_key_container.visible = false
		key_node.frame = 1
	else:
		key_node.frame = 0
