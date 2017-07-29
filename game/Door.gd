extends Sprite

signal monster_arrived

onready var sound_effect_player = get_node("SoundEffectPlayer")

var hunted = false

func _ready():
	if hunted:
		sound_effect_player.play("cloth1")
		set_process(true)

func _process(delta):
	# Volume varitation may be added later
	#sound_effect_player.voice_set_volume_scale_db(0, 1)
	pass
