extends Node2D

onready var sound_left = get_node("SoundLeft")
onready var sound_center = get_node("SoundCenter")
onready var sound_right = get_node("SoundRight")

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("play_left_sound"):
		sound_left.play("sample_sound_effect")
	elif Input.is_action_pressed("play_center_sound"):
		sound_center.play("sample_sound_effect")
	elif Input.is_action_pressed("play_right_sound"):
		sound_right.play("sample_sound_effect")
