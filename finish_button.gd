extends TextureRect

var in_focus = false

var pressed_texture = preload("res://finish_ui_box_pressed.png")
var focused_texture = preload("res://finish_ui_box_selected.png")
var normal_texture = preload("res://finish_ui_box.png")

func _ready():
	connect("focus_entered", self, "_focus_entered")
	connect("focus_exited", self, "_focus_exited")
	
	yield(get_tree(), "idle_frame")
	rect_position.y = -4

func _input(event):
	if in_focus:
		if Input.is_action_pressed("action"):
			texture = pressed_texture
		else:
			texture = focused_texture

func _focus_entered():
	in_focus = true
	texture = focused_texture

func _focus_exited():
	in_focus = false
	texture = normal_texture
