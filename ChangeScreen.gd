extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Play_button_down():
	get_tree().change_scene("Prototype.tscn")


func _on_Settings_button_down():
	get_tree().change_scene("ControlsMenu.tscn")


func _on_Exit_button_down():
	get_tree().quit()


func _on_Back_button_down():
	get_tree().change_scene("Menu.tscn")


func _on_Pause_button_down():
	get_tree().change_scene("Menu.tscn")
