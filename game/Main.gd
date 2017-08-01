extends Node2D

var door_scn = preload("door/Door.tscn")

onready var level_screen = get_node("GUI/LevelScreen")
onready var flashlight = get_node("Flashlight")
onready var sfx_manager = get_node("SFXManager")

var outro = preload("Outro.tscn")

# Level data and current instance
var level_data = [preload("level_data/Level1.tscn"),
					preload("level_data/Level2.tscn"),
					preload("level_data/Level3.tscn"),
					preload("level_data/Level4.tscn"),
					preload("level_data/Level5.tscn")]

var level_inst

# Progress information
var level = 0
var room = 0

# Ugly hack
var hunted

func _ready():
	randomize()
	
	flashlight.connect("batterie_value_changed", get_node("GUI/Batterie"), "set_value")
	
	show_level_screen()
	
	set_process(true)

func _process(delta):
	get_node("AmbientMusic").set_volume(1 - flashlight.get_color().r * .75)

func generate_level():
	print("generating")
	
	room += 1
	flashlight.force_out()
	flashlight.flash()
	
	if room > level_inst.rooms_per_level:
		if not level == level_data.size() - 1:
			level += 1
			room = 0
			flashlight.refill_batteries()
			show_level_screen()
		else:
			get_tree().change_scene_to(outro)
	
	# nodes aren't freed fast enough so...
	var prev_child_count = level_inst.get_node("Entrances").get_child_count()
	
	for child in level_inst.get_node("Entrances").get_children():
		child.queue_free()
	
	# Spawn doors in current room
	var spawns = level_inst.get_node("Spawns").get_children()
	var spawn_locations = range(spawns.size())
	
	for i in range(level_inst.doors_per_room):
		var random_spawn_point_index = randi() % spawn_locations.size()
		var spawn_point = spawn_locations[random_spawn_point_index]
		spawn_locations.remove(random_spawn_point_index)
		
		var door = door_scn.instance()
		door.set_pos(spawns[spawn_point].get_pos())
		
		level_inst.get_node("Entrances").add_child(door)
		
		if spawns[spawn_point].has_node("AudioOffset"):
			door.set_audio_offset(spawns[spawn_point].get_node("AudioOffset").get_pos().x)
		
		# fucking signals
		door.connect("used_door", self, "generate_level")
		door.connect("monster_arrived", self, "on_monster_arrived")
	
	# Let a random door be hunted
	var entrances = level_inst.get_node("Entrances").get_children()
	
	var hunted_index = prev_child_count + randi() % (entrances.size() - prev_child_count)
	entrances[hunted_index].hunted = true
	entrances[hunted_index].approaching_time = level_inst.monster_speed
	
	hunted = true

func on_monster_arrived():
	sfx_manager.play("game_over")
	room = 0
	flashlight.refill_batteries()
	
	show_level_screen(true)
	
func show_level_screen(monster_arrived = false):
	flashlight.hide()
	
	level_screen.get_node("LevelScreenLabel").set_text("LEVEL " + str(level + 1))
	level_screen.show()
	
	if not monster_arrived:
		sfx_manager.play("churchbell")
	
	get_tree().set_pause(true)

func restart():
	print("Starting level")
	flashlight.show()
	# Why is this needed
	get_node("SFXManager").stop_all()
	
	load_level()
	get_tree().set_pause(false)
	flashlight.flash()

func load_level():
	# Remove last level
	if has_node("Level"):
		var current_level = get_node("Level")
	
		current_level.queue_free()
		remove_child(current_level)
	
	# Add new level
	level_inst = level_data[level].instance()
	add_child(level_inst, true)
	
	generate_level()
