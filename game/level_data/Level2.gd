extends Node2D

# Sprite refs
var sprite_door_open = preload("res://door/door_open.png")
var sprite_door_closed = preload("res://door/door.png")

# Level config
var doors_per_room  = 3
var rooms_per_level = 5
var monster_speed   = 4

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
