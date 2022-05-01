extends TextureButton

onready var selected_letter_label = $SelectedLetter
onready var arrows = $Arrows
onready var arrow_up = $Arrows/Up
onready var arrow_down = $Arrows/Down

func _ready():
	connect("focus_entered", self, "_focus_entered")
	connect("focus_exited", self, "_focus_exited")
	
	arrows.visible = false

func _process(_delta):
	if arrows.visible:
		if Input.is_action_pressed("up"):
			arrow_up.frame = 1
		else:
			arrow_up.frame = 0
		
		if Input.is_action_pressed("down"):
			arrow_down.frame = 1
		else:
			arrow_down.frame = 0

func _focus_entered():
	arrows.visible = true

func _focus_exited():
	arrows.visible = false
