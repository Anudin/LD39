# something very bad happens if you click too fast...

# Monster visuals

# Sound
# Footstep
# Door open sound
# Maybe bells
# Maybe jumpscare

# Possible game mechanic changes and additions:
# make flashlight effect flashlight sized and focus on cursor! OR make monster faster upon use
# limit flashlight energy per level?
# light up level screen
# Non linear monster speed

# Level progression possibilities:
# - More doors
# - More rooms
# - Faster monster
# - Change timing and availability of flashlight

extends Node2D

var door_scn = preload("door/Door.tscn")

onready var level_dock = get_node("LevelDock")
onready var spawns_container
onready var entrances_container
onready var flashlight = get_node("Flashlight")
onready var floodlight = get_node("Floodlight")
onready var level_screen = get_node("LevelScreen")

# Level loading and progressing
var level_data = [preload("level_data/Level1.tscn"),
					preload("level_data/Level2.tscn"),
					preload("level_data/Level3.tscn"),
					preload("level_data/Level4.tscn"),
					preload("level_data/Level5.tscn")]

onready var level_inst

var level = 0
var room = 0

func _ready():
	randomize()
	
	show_level_screen()
	set_fixed_process(true)

func _fixed_process(delta):
	get_node("HUD/Batterie").set_value(flashlight.batterie)

func generate_level():
	room += 1
	
	if room > level_inst.rooms_per_level and not level == level_data.size() - 1:
		level += 1
		room = 0
		show_level_screen()
	
	# nodes aren't freed fast enough so...
	var prev_child_count = entrances_container.get_child_count()
	
	# here's the bug
	# queue free acts with a delay
	for child in entrances_container.get_children():
		child.queue_free()
	
	# Spawn doors in current room
	var spawns = spawns_container.get_children()
	var spawn_locations = range(spawns.size())
	
	for i in range(level_inst.doors_per_room):
		var random_spawn_point_index = randi() % spawn_locations.size()
		var spawn_point = spawn_locations[random_spawn_point_index]
		spawn_locations.remove(random_spawn_point_index)
		
		var door = door_scn.instance()
		door.set_pos(spawns[spawn_point].get_pos())
		entrances_container.add_child(door)
		
		# fucking signals
		door.connect("used_door", self, "generate_level")
		door.connect("monster_arrived", self, "on_monster_arrived")
	
	# Let a random door be hunted
	var entrances = entrances_container.get_children()
	
	var hunted_index = prev_child_count + randi() % (entrances.size() - prev_child_count)
	entrances[hunted_index].hunted = true
	entrances[hunted_index].approaching_time = level_inst.monster_speed

func on_monster_arrived():
	room = 0
	
	show_level_screen()
	
func show_level_screen():
	floodlight.hide()
	flashlight.hide()
	
	level_screen.get_node("LevelScreenLabel").set_text("LEVEL " + str(level + 1))
	level_screen.show()
	get_node("SamplePlayer2D").play("churchbell")
	
	get_tree().set_pause(true)

func restart():
	load_level()
	floodlight.show()
	floodlight.flash()
	flashlight.show()
	get_tree().set_pause(false)

func load_level():
	# Remove last level
	var current_level = level_dock.get_node("Level")
	current_level.queue_free()
	level_dock.remove_child(current_level)
	
	# Add new level
	level_inst = level_data[level].instance()
	level_dock.add_child(level_inst, true)
	
	# Setup logic
	spawns_container = level_inst.get_node("Spawns")
	entrances_container = level_inst.get_node("Entrances")
	
	generate_level()
