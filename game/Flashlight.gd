extends Light2D

onready var animation_player = get_node("AnimationPlayer")

func _ready():
	show()
	
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if not event.is_echo() and event.is_action("use_flashlight"):
		animation_player.play("light_flicker")