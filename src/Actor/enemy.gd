extends "res://src/Actor/Actor.gd"

########################################################################
#                          ENEMY INFORMATION                           #
# It always random movement at day but it will follow you if at night. #
########################################################################

var times = 0
var enter_time = 0
var entered = false
var rng = RandomNumberGenerator.new()
onready var obj = get_tree().get_root().get_node("LevelTemplete/Player")

func _ready() -> void:
	$Timer.start(3)
	vel = RandomMovement()
	preload("res://src/global.gd")

func _on_Area2D_body_entered(body: PhysicsBody2D):
	# Hitbox
	if body is Bullet or body is Sword:
		times +=1
		body.queue_free()
		$attacked.play()
		if times >= 3:
			Globals.eScore += 1
			queue_free()
func _process(delta):
	if entered:
		enter_time += 1
	if enter_time >= 40:
		times += 1
		enter_time = 0
	
	if times >= 3:
		Globals.eScore += 1
		Globals.list_enemy1.erase(self)
		queue_free()
func _physics_process(delta: float) -> void:
	$enemy.play()

	# Follow player at the night
	if Globals.timeState == "night":
		var dir = (obj.global_position - global_position).normalized()
		vel = move_and_slide(dir * speed * 2.5)
	else:
		if is_on_wall():
			vel = RandomMovement()
		vel = move_and_slide(vel, Vector2.ZERO)
	
	if vel.y > -75 and vel.y < 75:
		if vel.x > 0:
			$enemy.set_animation("right")
		elif vel.x < 0:
			$enemy.set_animation("left")
	else:
		if vel.y > 0:
			$enemy.set_animation("bottom")
		elif vel.y < 0:
			$enemy.set_animation("top")

func _on_Timer_timeout():
	vel = RandomMovement()
	
func RandomMovement() -> Vector2:
	var vel_x = rng.randf_range(-speed.x, speed.x)
	var vel_y = rng.randf_range(-speed.y, speed.y)
	
	while(abs(vel_x) < 65 and abs(vel_y) < 65):
		rng.randomize()
		vel_x = rng.randf_range(-speed.x, speed.x)
		vel_y = rng.randf_range(-speed.y, speed.y)
	
	return Vector2(vel_x,vel_y)

func _on_Area2D_area_entered(area):
	if area.name == "AttackArea":
		entered = true
func _on_Area2D_area_exited(area):
	if area.name == "AttackArea":
		entered = false
