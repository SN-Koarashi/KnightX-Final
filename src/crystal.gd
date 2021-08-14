extends StaticBody2D



func _on_check_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		Globals.health = 3
	pass # Replace with function body.
