extends "res://src/Actor/Actor.gd"

var times = 0

func _ready() -> void:
	vel.x = -speed.x
	preload("res://src/global.gd")

func _on_Area2D_body_entered(body: PhysicsBody2D):
	# Hitbox
	if body.name != "Player":
		times +=1
		body.queue_free()
		$attacked.play()
		if times >= 5:
			Globals.eScore += 35
			get_node("CollisionShape2D").disabled = true
			queue_free()

func _physics_process(delta: float) -> void:
	$SZombie.play()
	vel.y += gra * delta
	if is_on_wall():
		vel.x *= -1.0
	if vel.x > 0:
		$SZombie.set_flip_h(false)
		$SZombie.set_offset(Vector2(0,0))
	else:
		$SZombie.set_flip_h(true)
		$SZombie.set_offset(Vector2(-120,0))
	vel.y = move_and_slide(vel, Vector2.UP).y



