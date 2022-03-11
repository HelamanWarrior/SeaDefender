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
	print("Playing:")
	get_tree().change_scene("Prototype.tscn")
	pass # Replace with function body.


func _on_Settings_button_down():
	print("Going to Controls Menu:")
	get_tree().change_scene("ControlsMenu.tscn")
	pass # Replace with function body.


func _on_Exit_button_down():
	print("Exiting:")
	get_tree().quit()
	pass # Replace with function body.


func _on_Back_button_down():
	print("Going To Main Menu:")
	get_tree().change_scene("Menu.tscn")
	pass # Replace with function body.
