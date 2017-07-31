extends Light2D

onready var sound = get_node("SamplePlayer2D")
onready var anim = get_node("AnimationPlayer")

export var batterie_length = 3
var batterie = 100

var on = false
var follow = false

func _ready():
	set_process(true)
	set_process_unhandled_input(true)

func _process(delta):
	if on:
		batterie -= delta * (100 / batterie_length)
		
		if batterie <= 0:
			batterie = 0
			on = false
			anim.play("light_off")
	
	if follow:
		set_pos(get_global_mouse_pos())

func _unhandled_input(event):
	if event.is_action_pressed("use") and batterie > 0:
		print("Toggle flashlight")
		
		if on:
			on = false
			sound.play("click_off")
			anim.play("light_off")
		else:
			on = true
			sound.play("click_on")
			anim.play("light_on")

func _on_AnimationPlayer_animation_started( name ):
	follow = false
	set_pos(Vector2(-1280, 0))

func _on_AnimationPlayer_finished():
	follow = true

func refill_batteries():
	batterie = 100
