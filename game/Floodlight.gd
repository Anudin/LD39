extends Light2D

onready var anim = get_node("AnimationPlayer")

func _ready():
	pass

func flash():
	anim.play("flash")
