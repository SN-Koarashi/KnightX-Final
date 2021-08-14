extends StaticBody2D
onready var obj = get_tree().get_root().get_node("LevelTemplete/Player")
onready var Globals = get_node("/root/Globals")

func _on_check_input_event(viewport, event, shape_idx):
	if !Globals.openChestMenu and event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		#print(obj.get_node("Camera2D"))
		Globals.openChestMenu = true
	pass # Replace with function body.

func _process(delta):
	if Globals.openChestMenu:
		$chest.set_frame(1)
	else:
		$chest.set_frame(0)
