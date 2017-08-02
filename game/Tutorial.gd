extends Node2D

var game = preload("Intro.tscn")

onready var light = get_node("Light")

enum State {
	doors,
	flashlight
}

var state = State.doors

var hunted = true

func _ready():
	randomize()
	
	get_node("Door1").connect("used_door", self, "on_used_door")
	get_node("Door1").connect("monster_arrived", self, "on_monster_arrived")
	get_node("Door2").connect("used_door", self, "on_used_door")
	get_node("Door2").connect("monster_arrived", self, "on_monster_arrived")
	
	var timer = get_node("Timer")
	timer.set_wait_time(5)
	timer.connect("timeout", self, "power_out")
	timer.start()
	
	set_process(true)

var confirmable = false
var process_open = false
var wait_for_click = false

func _process(delta):
	light.batterie = 100
	
	if wait_for_click and Input.is_action_pressed("use"):
		wait_for_click = false
		
		var timer = get_node("Timer")
		timer.set_wait_time(6)
		timer.disconnect("timeout", self, "power_out")
		timer.connect("timeout", self, "make_noise")
		timer.start()
	
	if (confirmable and Input.is_action_pressed("confirm")) or Input.is_key_pressed(KEY_S):
		get_tree().change_scene_to(game)

func power_out():
	get_node("GUI/Label").set_text("Suddenly the power went out?")
	light.show()
	light.flash()
	
	wait_for_click = true

func make_noise():
	get_node("GUI/Label").set_text("Something is coming...\nClick on the silent door to get to safety!")
	
	get_node("Door1").reset_state()
	get_node("Door2").reset_state()
	
	var hunted_index = str(1 + randi() % 2)
	
	get_node("Door" + hunted_index).hunted = true
	get_node("Door" + hunted_index).approaching_time = 4
	
	process_open = true

func on_used_door():
	if process_open:
		get_node("Door1").reset_state()
		get_node("Door2").reset_state()
		
		get_node("GUI/Label").set_text("Good.\nThrough clicking on the right doors\nyou will traverse to the next room.\nPress space to start the game.")
		confirmable = true

func on_monster_arrived():
	if process_open:
		get_node("GUI/Label").set_text("That's not good!\nYou'll get another chance.")
	
	var timer = get_node("Timer")
	timer.set_wait_time(3)
	timer.connect("timeout", self, "make_noise")
	timer.start()
	
	process_open = false