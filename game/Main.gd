extends Node2D

var door_scn = preload("Door.tscn")

onready var spawns_container = get_node("SpawnsContainer")
onready var entrances_container = get_node("EntrancesContainer")
onready var flashlight = get_node("Flashlight")
onready var restart_screen = get_node("RestartScreen")

func _ready():
	randomize()
	
	restart_screen.connect("restart_game", self, "restart")
	
	generate_level()

func generate_level():
	# nodes aren't freed fast enough so...
	var prev_child_count = entrances_container.get_child_count()
	
	for child in entrances_container.get_children():
		child.queue_free()
	
	# Spawn doors in current room
	for child in spawns_container.get_children():
		var door = door_scn.instance()
		door.set_pos(child.get_pos())
		entrances_container.add_child(door)
		
		# fucking signals
		door.connect("used_door", self, "generate_level")
		door.connect("monster_arrived", self, "on_monster_arrived")
		door.connect("monster_arrived", flashlight, "on_monster_arrived")
	
	# Let a random door be hunted
	var entrances = entrances_container.get_children()
	entrances[prev_child_count + randi() % spawns_container.get_child_count()].hunted = true
	
	# Show level
	flashlight.toggle_on()

func on_monster_arrived():
	#restart_screen.show()
	#get_tree().set_pause(true)
	pass

func restart():
	pass