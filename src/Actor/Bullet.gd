extends RigidBody2D
class_name Bullet

func _ready():
	$Timer.start(1)

func _on_Timer_timeout():
	queue_free()
