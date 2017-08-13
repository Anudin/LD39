extends Light2D

signal batterie_value_changed

onready var sound = get_node("SamplePlayer2D")
onready var anim = get_node("AnimationPlayer")

export var batterie_length = 3
var batterie = 100

var on = false

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
		
		emit_signal("batterie_value_changed", batterie)

var process_touch = true

func _unhandled_input(event):
	if on:
		print("moving")

		# Follow mouse cursor - mouse movement
		if event.type == InputEvent.MOUSE_MOTION:
			set_pos(event.pos)

		# Follow mouse cursor - drag
		if OS.get_name() == "Android" and event.type == InputEvent.SCREEN_DRAG:
			set_pos(event.pos)

			print("ignore next touch event")
			process_touch = false

	# Toggle flashlight
	if event.type == InputEvent.SCREEN_TOUCH and not event.is_pressed() and batterie > 0:
		if process_touch:
			if not on:
				print("POSITION SET")
				set_pos(event.pos)

			print("toggle flashlight")
			toggle_state()
		else:
			print("consume next touch event")
			process_touch = true

func toggle_state():
	if on:
		on = false
		sound.play("click_off")
		anim.play("light_off")
	else:
		on = true
		sound.play("click_on")
		anim.play("light_on")

func refill_batteries():
	batterie = 100
	emit_signal("batterie_value_changed", batterie)
	force_out()

func force_out():
	on = false
	set_color(Color(0))

func flash():
	anim.play("flash")

func _on_AnimationPlayer_animation_started( name ):
	if name == "flash":
		print("light position reset")

		on = false
		set_pos(Vector2(640, 360))
