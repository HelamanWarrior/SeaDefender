extends Node2D

const DEADZONE = 0.2

onready var wasd_key_container = $wasd_keys
onready var arrow_key_container = $arrow_keys
onready var generic_key_container = $generic_key
onready var gamepad_container = $gamepad

onready var a_key = $wasd_keys/a_key
onready var s_key = $wasd_keys/s_key
onready var d_key = $wasd_keys/d_key
onready var w_key = $wasd_keys/w_key

onready var left_key = $arrow_keys/left_key
onready var down_key = $arrow_keys/down_key
onready var right_key = $arrow_keys/right_key
onready var up_key = $arrow_keys/up_key

onready var space_key = $generic_key/space_key
onready var a_button = $gamepad/a_button
onready var joystick = $gamepad/joystick

onready var tween = $Tween

func _ready():
	GameEvent.connect("hide_controls", self, "hide_controls")

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
	
	if Input.is_joy_button_pressed(0, 0):
		gamepad_visible()
		
		a_button.frame = 1
	else:
		a_button.frame = 0
	
	if abs(Input.get_joy_axis(0, JOY_AXIS_0)) > DEADZONE:
		gamepad_visible()
		
		if Input.get_joy_axis(0, JOY_AXIS_0) > 0:
			joystick.frame = 3
		else:
			joystick.frame = 2
	elif abs(Input.get_joy_axis(0, JOY_AXIS_1)) > DEADZONE:
		gamepad_visible()
		
		if Input.get_joy_axis(0, JOY_AXIS_1) < 0:
			joystick.frame = 4
		else:
			joystick.frame = 1
	else:
		joystick.frame = 0

func gamepad_visible():
	gamepad_container.visible = true
	wasd_key_container.visible = false
	arrow_key_container.visible = false
	generic_key_container.visible = false

func animate_key_press(key_node, scancode, container):
	if Input.is_key_pressed(scancode):
		if !container.visible:
			wasd_key_container.visible = false
			arrow_key_container.visible = false
			
			if container != gamepad_container:
				generic_key_container.visible = true
			else:
				generic_key_container.visible = false
				
			gamepad_container.visible = false
			
			container.visible = true
			
		key_node.frame = 1
	else:
		key_node.frame = 0

func hide_controls():
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0, 0), 0.2)
	tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free()
