extends RigidBody2D
class_name Sword

func _ready():
	get_node("Timer").start(0.5)

func _on_Timer_timeout():
	queue_free()
