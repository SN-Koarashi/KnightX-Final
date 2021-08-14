extends StaticBody2D



func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.global_position.x = 12771
		body.global_position.y = 2522
