extends RigidBody2D
class_name Soul

onready var BULLET = preload("Bullet.tscn")
func _ready():
	get_node("Timer").start(1)

func _on_Timer_timeout():
	
	for n in 8:
		var bullet =  BULLET.instance()
		get_node("/root/LevelTemplete").add_child(bullet)
		bullet.global_position.x = self.global_position.x
		bullet.global_position.y = self.global_position.y
		
		if n == 0:
			bullet.global_position.x = self.global_position.x - 100
			bullet.apply_impulse(Vector2(80,80),Vector2(-1625,0))
		elif n == 1:
			bullet.global_position.x = self.global_position.x - 100
			bullet.global_position.y = self.global_position.y - 100
			bullet.apply_impulse(Vector2(80,80),Vector2(-1625,-1625))
		elif n == 2:
			bullet.global_position.y = self.global_position.y - 100
			bullet.apply_impulse(Vector2(80,80),Vector2(0,-1625))
		elif n == 3:
			bullet.global_position.x = self.global_position.x + 100
			bullet.global_position.y = self.global_position.y - 100
			bullet.apply_impulse(Vector2(80,80),Vector2(1625,-1625))
		elif n == 4:
			bullet.global_position.x = self.global_position.x + 100
			bullet.apply_impulse(Vector2(80,80),Vector2(1625,0))
		elif n == 5:
			bullet.global_position.x = self.global_position.x + 100
			bullet.global_position.y = self.global_position.y + 100
			bullet.apply_impulse(Vector2(80,80),Vector2(1625,1625))
		elif n == 6:
			bullet.global_position.y = self.global_position.y + 100
			bullet.apply_impulse(Vector2(80,80),Vector2(0,1625))
		elif n == 7:
			bullet.global_position.x = self.global_position.x - 100
			bullet.global_position.y = self.global_position.y + 100
			bullet.apply_impulse(Vector2(80,80),Vector2(-1625,1625))
	queue_free()
