extends Light2D

onready var anim = get_node("AnimationPlayer")

var on = false
var follow = false

func _ready():
	set_process(true)
	set_process_unhandled_input(true)

func _process(delta):
	if follow:
		set_pos(get_global_mouse_pos())

func _unhandled_input(event):
	if event.is_action_pressed("use"):
		if on:
			on = false
			anim.play("light_off")
		else:
			on = true
			anim.play("light_on")

func _on_AnimationPlayer_animation_started( name ):
	follow = false
	set_pos(Vector2(-1280, 0))

func _on_AnimationPlayer_finished():
	follow = true
