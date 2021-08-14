extends Control
onready var Globals = get_node("/root/Globals")

func _ready():
		$VBoxContainer2/NTime.text =  str(Globals.time_bonus)
		$VBoxContainer2/NSc.text = str(Globals.eScore)
		$VBoxContainer2/NTot.text = str(Globals.score)
		$Label.text = "Spend Time (" + str(Globals.time_format) + ") "
		
		$Victory.play()
		
func _input(event):
	if Input.get_action_strength("Reflash"):
		get_tree().change_scene("res://src/Main.tscn")
