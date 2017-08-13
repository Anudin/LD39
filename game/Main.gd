# Audio setup screen
#	-> max + min setup
# with correct use of UI nodes

# Add monster close audio clue
# Add random amount of silence
# Maybe add a screen tearing shader

# === POST LD
# Remove flashlight - keep small ambient light
# 	-> only black out doors?
# Add movement / graphic cues for enemy

# === POST LD - OPTIONAL
# Remove door timer
# Freeing of old levels

extends Node2D

var door_scn = preload("door/Door.tscn")
var enemy_scn = preload("enemy/Enemy.tscn")
var outro_scn = preload("Outro.tscn")

onready var level_screen = get_node("GUI/LevelScreen")
onready var light = get_node("Light")
onready var sfx_manager = get_node("SFXManager")

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

func _ready():
	randomize()

	# Setup status bar for flashlight batteries
	light.connect("batterie_value_changed", get_node("GUI/Batterie"), "set_value")
	
	show_level_screen()
	
	set_process(true)

func _process(delta):
	get_node("AmbientMusic").set_volume(1 - light.get_color().r * .75)

var enemy

func generate_level():
	print("generate_level")
	
	room += 1
	light.force_out()
	light.flash()
	
	if room > level_inst.rooms_per_level:
		if not level == level_data.size() - 1:
			enemy.chase = false
			level += 1
			room = 0
			light.refill_batteries()
			show_level_screen()

			return
		else:
			get_tree().change_scene_to(outro_scn)
	
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
			door.audio_offset = spawns[spawn_point].get_node("AudioOffset").get_pos().x
		
		# fucking signals
		door.connect("used_door", self, "generate_level")
	
	# Let a random door be hunted
	var entrances = level_inst.get_node("Entrances").get_children()
	
	var hunted_index = prev_child_count + randi() % (entrances.size() - prev_child_count)
	enemy = enemy_scn.instance()
	enemy.time_until_arrival = level_inst.monster_speed
	enemy.connect("monster_arrived", self, "on_monster_arrived")
	entrances[hunted_index].add_child(enemy, true)

func on_monster_arrived():
	sfx_manager.play("game_over")
	room = 0
	light.refill_batteries()
	
	show_level_screen(true)
	
func show_level_screen(monster_arrived = false):
	light.hide()
	
	level_screen.get_node("Label").set_text("LEVEL " + str(level + 1))
	level_screen.show()
	
	if not monster_arrived:
		sfx_manager.play("churchbell")
	
	get_tree().set_pause(true)

func start_level():
	print("start_level")
 
	# Stop effects so they don't disrupt gameplay
	get_node("SFXManager").stop_all()
	
	load_level()
	light.show()
	light.flash()
	
	get_tree().set_pause(false)

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
