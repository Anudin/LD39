extends Control

signal restart_game

var main_scn = load("Main.tscn")

func _ready():
	set_process_input(true)

func _input(event):
	# Fuck restarting for now - THIS IS A PROTOTYPE
	if event.is_action_pressed("restart"):
		get_tree().set_current_scene(main_scn.instance())
		get_tree().set_pause(false)