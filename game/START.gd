extends Node

func _ready():
	get_node("../GUI/Label").set_text("Press SPACE to start tutorial.")

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("confirm"):
		get_node("../Light").show()
		get_node("../Light").flash()
		get_parent().change_state(load("WHAT_IF.tscn"))
