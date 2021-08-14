extends "res://src/Actor/Actor.gd"

########################################################################
#                          ENEMY INFORMATION                           #
# If you too close it, it will follow you.                             #
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
		get_node("CollisionShape2D").disabled = true
		Globals.list_enemy2.erase(self)
		queue_free()

func _physics_process(delta: float) -> void:
	$enemy2.play()
	
	if global_position.distance_to(obj.global_position) > 275:
		# Random movement
		if $Timer.is_stopped():
			$Timer.start(3)
			vel = RandomMovement()
		
		if is_on_wall():
			vel = RandomMovement()
		vel = move_and_slide(vel, Vector2.ZERO)
	else:
		$Timer.stop()
		# Follow player forever
		var dir = (obj.global_position - global_position).normalized()
		vel = move_and_slide(dir * speed * 1.775)
	
	if vel.y > -75 and vel.y < 75:
		if vel.x > 0:
			$enemy2.set_animation("right")
		elif vel.x < 0:
			$enemy2.set_animation("left")
	else:
		if vel.y > 0:
			$enemy2.set_animation("bottom")
		elif vel.y < 0:
			$enemy2.set_animation("top")

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
