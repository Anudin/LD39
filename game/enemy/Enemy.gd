extends Node2D

signal monster_arrived

onready var sfx_player = get_node("SFXPlayer")

var chase = true setget set_chase

var time_until_arrival = 3

# Footstep volume
onready var volume_start = get_node("/root/Global").initial_step_volume
var volume_current

func _ready():
	volume_current = volume_start

	sfx_player.set_pos(Vector2(get_parent().audio_offset, 0))
	sfx_player.play("steps")

	print("Enemy _ready, offset ", sfx_player.get_pos())

	set_process(true)

func _process(delta):
	if chase:
		volume_current -= (volume_start / time_until_arrival) * delta
				
		if volume_current >= 0:
			# Stop step sound
			sfx_player.stop_all()
			
			print("emiting: monster_arrived...")
			
			var door = get_parent()
			door.open()
			emit_signal("monster_arrived")
		else:
			sfx_player.voice_set_volume_scale_db(0, volume_current)	

func reset_state():
	volume_current = volume_start

func set_chase(value):
	chase = value

	if value:
		sfx_player.play("steps")
	else:
		sfx_player.stop_all()