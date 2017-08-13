extends Node2D

func _ready():
	get_node("Button").connect("pressed", self, "on_confirm")

func on_confirm():
	get_tree().change_scene("Tutorial.tscn")