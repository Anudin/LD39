extends Node2D

var door_scn = preload("Door.tscn")

onready var spawns = get_node("Spawns")

func _ready():
	for child in spawns.get_children():
		var door = door_scn.instance()
		door.set_pos(child.get_pos())
		door.hunted = true
		add_child(door)
	
	set_process(true)

func _process(delta):
	pass
