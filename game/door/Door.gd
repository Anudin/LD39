extends Node2D

signal used_door

onready var sprite_open = get_node("Open")
onready var sprite_close = get_node("Close")
onready var sound_effect_player = get_node("SoundEffectPlayer")
onready var sound_timer = get_node("SoundTimer")

var audio_offset = 0

func _ready():
	set_process_input(true)

func open():
	sound_effect_player.stop_all()
	sound_effect_player.play("open_door")
	toggle_state()

func toggle_state():
	if sprite_open.is_visible():
		sprite_open.hide()
		sprite_close.show()
	else:
		sprite_open.show()
		sprite_close.hide()

func _input(event):
	if event.is_action_pressed("use") and mouse_over_door():
		get_tree().set_input_as_handled()
		
		open()

		# Ugly hack
		var enemy = get_node("/root/Main").enemy

		if enemy != null:
			enemy.chase = false

		if has_node("Enemy"):
			get_node("Enemy").emit_signal("monster_arrived")
		else:
			sound_timer.set_wait_time(0.66)
			sound_timer.start()	

# Manual check is needed since Area2Ds input method is called
# after _input and _unhandled_input
func mouse_over_door():
	var diff = (get_pos() + sprite_open.get_offset()) - get_global_mouse_pos()
	
	# Sprite spans 60 x 100
	if abs(diff.x) <= 60 and abs(diff.y) <= 100:
		return true

	return false

func _on_SoundTimer_timeout():
	print("emiting: used_door...")

	emit_signal("used_door")

func unleash():
	get_node("Enemy").queue_free()
	remove_child(get_node("Enemy"))

func reset_state():
	sprite_open.hide()
	sprite_close.show()
	
	sound_effect_player.stop_all()
