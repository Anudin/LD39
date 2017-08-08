extends Node

func _ready():
	get_node("../Light").set_process_unhandled_input(true)
	
	get_node("../GUI/TexturedBatterie").show()

	get_node("../GUI/Label").set_text("Click anywhere to start your flashlight.")

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("use"):
		get_parent().change_state(load("PROCEED.tscn"))