extends TextureButton

onready var selected_letter_label = $SelectedLetter
onready var arrows = $Arrows
onready var arrow_up = $Arrows/Up
onready var arrow_down = $Arrows/Down
onready var arrow_press_timer = $ArrowPressTimer

var arrow_up_pressed = false
var arrow_down_pressed = false

func _ready():
	connect("focus_entered", self, "_focus_entered")
	connect("focus_exited", self, "_focus_exited")
	
	arrows.visible = false

func _process(_delta):
	rect_rotation = lerp(rect_rotation, 0, 0.2)
	arrow_up.global_scale = lerp(arrow_up.global_scale, Vector2(1, 1), 0.2)
	arrow_down.global_scale = lerp(arrow_down.global_scale, Vector2(1, 1), 0.2)
	if abs(rect_rotation) < 1:
		rect_rotation = 0
	
	if arrows.visible:
		if Input.is_action_just_pressed("up"):
			arrow_up.frame = 1
			arrow_up.global_scale = Vector2(1.5, 1)
			rect_rotation = rand_range(15, 30)
			arrow_up_pressed = true
			arrow_press_timer.start()
		elif Input.is_action_just_pressed("down"):
			arrow_down.frame = 1
			arrow_down.global_scale = Vector2(1.5, 1)
			rect_rotation = rand_range(-15, -30)
			arrow_down_pressed = true
			arrow_press_timer.start()

func _focus_entered():
	arrows.visible = true
	rect_rotation = rand_range(10, 15) * ((round(rand_range(0, 1)) * 2) - 1)

func _focus_exited():
	arrows.visible = false

func _on_ArrowPressTimer_timeout():
	if arrow_up_pressed:
		arrow_up.frame = 0
		arrow_up_pressed = false
	elif arrow_down_pressed:
		arrow_down.frame = 0
		arrow_down_pressed = false
