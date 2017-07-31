extends Node2D

signal used_door
signal monster_arrived

onready var collider = get_node("CollisionShape2D")
onready var sprite_open = get_node("Open")
onready var sprite_close = get_node("Close")
onready var sound_effect_player = get_node("SoundEffectPlayer")

var hunted = false
var approaching_time = 3
var approaching_start = -25
var approaching_current = -25

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if hunted:
		if not sound_effect_player.is_voice_active(0):
			sound_effect_player.play("steps")
			pass
		else:
			approaching_current -= approaching_start / approaching_time * delta
			
			if approaching_current >= 0:
				unleash()
			
			sound_effect_player.voice_set_volume_scale_db(0, approaching_current)

func unleash():
	sound_effect_player.stop_all()
	sound_effect_player.play("monster_voice")
	hunted = false
	toggle_state()
	emit_signal("monster_arrived")

func toggle_state():
	if sprite_open.is_visible():
		sprite_open.hide()
		sprite_close.show()
	else:
		sprite_open.show()
		sprite_close.hide()

func _input(event):
	if event.is_action_pressed("use") and mouse_over_door():
		print("Door opened")
		
		get_tree().set_input_as_handled()
		
		if hunted:
			unleash()
		else:
			emit_signal("used_door")

func mouse_over_door():
	var diff = collider.get_global_pos() - get_global_mouse_pos()
	
	# Collider spans 60 x 100
	if abs(diff.x) <= 30 and abs(diff.y) <= 50:
		return true
	
	#print("Trying to open door with: ", diff)
	
	return false
