extends Light2D

onready var animation_player = get_node("AnimationPlayer")

func _ready():
	show()
	
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if not animation_player.is_playing() and event.is_action("use"):
		animation_player.play("light_flicker")
		#penalty

func toggle_on():
	animation_player.play("light_flicker")

func on_monster_arrived():
	animation_player.play("light_flicker_to_on")