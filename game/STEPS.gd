extends Node

func _ready():
	get_node("../GUI/Label").set_text("Alright this is how you proceed through rooms.\nAt the start of every room the light flashes\nto give you a chance to memorize the level.\nOne final tip before you play:\nIf you hear noice - run away from it.\n\nPress SPACE to start and have fun!")
	
	get_node("../Light").set_process_unhandled_input(false)
	get_node("../Light").flash()

	get_node("../Door1").set_process_input(false)
	get_node("../Door2").set_process_input(false)

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("confirm"):
		get_tree().change_scene("Intro.tscn")