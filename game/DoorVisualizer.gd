extends Node2D

var doors = Array()
var door_scn = preload("Door.tscn")

func _ready():
	if get_tree().is_editor_hint():
		for child in get_children():
			var door = door_scn.instance()
			doors.append(door)
			add_child(door)
		
		set_process(true)

func _process(delta):
	print("")
	
	for i in range(doors.size()):
		var door = doors[i]
		
		door.set_pos(get_children()[i].get_pos())