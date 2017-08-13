extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if is_visible() and event.type == InputEvent.SCREEN_TOUCH and not event.is_pressed():
		print("LevelScreen _input")
		
		get_tree().set_input_as_handled()
		
		hide()
		get_node("/root/Main").start_level()
