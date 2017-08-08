extends Node2D

var state = preload("START.tscn")

var enemy

func _ready():
	# Disable inputs until they are explained
	get_node("Light").set_process_unhandled_input(false)
	get_node("Door1").set_process_input(false)
	get_node("Door2").set_process_input(false)

	add_child(state.instance(), true)

	set_process(true)

func _process(delta):
	if Input.is_key_pressed(KEY_S):
			get_tree().change_scene("Intro.tscn")

	# Ensure infinite battery in tutorial
	get_node("Light").batterie = 100

	# Adjust font color to light
	var light_color = get_node("Light").get_color()
	var font_color = Color(1 - light_color.r, 1 - light_color.r, 1 - light_color.r)

	get_node("GUI/Label").set("custom_colors/font_color", font_color)

func change_state(state):
	self.state = state
	
	# Remove current state
	var current_state = get_node("State")
	current_state.queue_free()
	remove_child(current_state)

	# Add new state
	add_child(state.instance(), true)

func restart_state():
	change_state(state)