extends Node2D
var vi = true

func _ready():
	$TrapArea.connect("body_entered", get_node("/root/LevelTemplete/Player"), "_on_TrapArea_body_entered")
	$Timer.start(3)

func _on_Timer_timeout():
	if vi:
		$trap.scale.x = 0
		$trap.scale.y = 0
		vi = false
	else:
		$trap.scale.x = 1.3
		$trap.scale.y = 1
		vi = true
