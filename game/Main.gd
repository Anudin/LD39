# level progress like LEVEL 1 (loud sound in background)
# Add more level progression -> room number, faster monster?

# flashlight mechanic

# Add level visuals / connector visuals
# Monster visuals

# Sound

extends Node2D

var door_scn = preload("Door.tscn")

onready var spawns_container = get_node("SpawnsContainer")
onready var entrances_container = get_node("EntrancesContainer")
onready var flashlight = get_node("Flashlight")
onready var restart_screen = get_node("RestartScreen")

var level = 0
var room = 0
# Format: [number_of_doors, use_upper_area, rooms_per_level, monster_speed]
var level_data=[[2, false, 3, 3],
				[3, false, 5, 3],
				[3, true, 5, 3],
				[4, true, 5, 3],
				[5, true, 5, 3]]

func _ready():
	randomize()
	
	restart_screen.connect("restart_game", self, "restart")
	
	generate_level()

func generate_level():
	room += 1
	
	if room > level_data[level][2] and not level == level_data.size() - 1:
		level += 1
	
	print(level)
	
	# nodes aren't freed fast enough so...
	var prev_child_count = entrances_container.get_child_count()
	
	for child in entrances_container.get_children():
		child.queue_free()
	
	# Spawn doors in current room
	var spawns = spawns_container.get_children()
	var spawn_indexes = range(spawns.size())
	
	# In the early levels we won't use all the possible spawns
	if not level_data[level][1]:
		spawn_indexes.resize(3)
	
	for i in range(level_data[level][0]):
		var random_number = randi() % spawn_indexes.size()
		var spawn_point = spawn_indexes[random_number]
		spawn_indexes.remove(random_number)
		
		var door = door_scn.instance()
		door.set_pos(spawns[spawn_point].get_pos())
		entrances_container.add_child(door)
		
		# fucking signals
		door.connect("used_door", self, "generate_level")
		door.connect("monster_arrived", self, "on_monster_arrived")
		door.connect("monster_arrived", flashlight, "on_monster_arrived")
	
	# Let a random door be hunted
	var entrances = entrances_container.get_children()
	entrances[prev_child_count + randi() % level_data[level][0]].hunted = true
	
	# Show level
	flashlight.toggle_on()

func on_monster_arrived():
	level = 0
	room = 0

func restart():
	pass