extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if is_visible() and event.is_action_pressed("use"):
		print("LevelScreen _input")
		
		get_tree().set_input_as_handled()
		
		hide()
		get_node("/root/Main").start_level()
