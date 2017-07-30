extends Node2D

signal used_door
signal monster_arrived

onready var sprite_open = get_node("Open")
onready var sprite_close = get_node("Close")
onready var sound_effect_player = get_node("SoundEffectPlayer")

var hunted = false
var approaching_time = 3
var approaching_start = -25
var approaching_current = -25

func _ready():
	set_process(true)

func _process(delta):
	if hunted:
		if not sound_effect_player.is_voice_active(0):
			#sound_effect_player.play("steps")
			pass
		else:
			#approaching_current -= approaching_start / approaching_time * delta
			
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

func _on_Door_input_event( viewport, event, shape_idx ):	
	if event.is_action_pressed("use"):
		if hunted:
			unleash()
		else:
			emit_signal("used_door")
