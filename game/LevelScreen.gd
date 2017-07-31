extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)

func _input(event):
	if is_visible() and event.is_action_pressed("use"):
		print("Level screen swallowing input")
		
		get_tree().set_input_as_handled()
		hide()
		get_node("/root/Main").restart()
