extends Node

func _ready():
    get_node("../GUI/Label").set_text("Battery usage is disabled in tutorial.\nCheck the status bar in the upper right corner regulary.\nGreat, now try to get to the next room.")
    
    get_node("../Door1").set_process_input(true)
    get_node("../Door2").set_process_input(true)

    get_node("../Door1").connect("used_door", self, "on_used_door")
    get_node("../Door2").connect("used_door", self, "on_used_door")

func on_used_door():
    get_parent().change_state(load("STEPS.tscn"))