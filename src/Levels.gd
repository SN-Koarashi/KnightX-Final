extends Node2D
onready var Globals = get_node("/root/Globals")
onready var ENEMY1 = preload("Actor/enemy.tscn")
onready var ENEMY2 = preload("Actor/enemy2.tscn")
onready var ENEMY3 = preload("Actor/enemy3.tscn")

var gameTime = 0

func _ready():
	Globals.timeState = "day"
	$MusicDay.volume_db = Globals.music_sound
	$MusicNight.volume_db = Globals.music_sound
	$Timer.start(1)

func _on_Timer_timeout():
	$MusicDay.volume_db = Globals.music_sound
	$MusicNight.volume_db = Globals.music_sound
	gameTime += 1
	if !$day_night.is_playing():
		if Globals.timeState == "day" and gameTime >= 120 or Globals.timeState == "night" and gameTime >= 90:
			if Globals.timeState == "day":
				$day_night.set_current_animation("ToNight")
				$day_night.play()
				Globals.timeState = "night"
				gameTime = 0
				$MusicDay.stop()
				$MusicNight.play()
				
				respawnMob()
			elif Globals.timeState == "night":
				$day_night.set_current_animation("ToDay")
				$day_night.play()
				Globals.timeState = "day"
				gameTime = 0
				$MusicDay.play()
				$MusicNight.stop()
func respawnMob():
	for n in (10 - Globals.list_enemy1.size()):
		var centerpos = $EnemyArea1/CollisionShape2D.position + $EnemyArea1.position
		var sizeColl = $EnemyArea1/CollisionShape2D.shape.extents
		var x = (randi() % int(sizeColl.x)) - int((sizeColl.x/2)) + int(centerpos.x)
		var y = (randi() % int(sizeColl.y)) - int((sizeColl.y/2)) + int(centerpos.y)
		
		var newEnemy = ENEMY1.instance()
		get_node("/root/LevelTemplete").add_child(newEnemy)
		newEnemy.global_position.x = x
		newEnemy.global_position.y = y
		
		Globals.list_enemy1.push_back(newEnemy)
	for i in (7 - Globals.list_enemy2.size()):
		var centerpos = $EnemyArea2/CollisionShape2D.position + $EnemyArea2.position
		var sizeColl = $EnemyArea2/CollisionShape2D.shape.extents
		var x = (randi() % int(sizeColl.x)) - int((sizeColl.x/2)) + int(centerpos.x)
		var y = (randi() % int(sizeColl.y)) - int((sizeColl.y/2)) + int(centerpos.y)
		
		var newEnemy = ENEMY2.instance()
		get_node("/root/LevelTemplete").add_child(newEnemy)
		newEnemy.global_position.x = x
		newEnemy.global_position.y = y
		
		Globals.list_enemy2.push_back(newEnemy)
	for g in (5 - Globals.list_enemy3.size()):
		var centerpos = $EnemyArea3/CollisionShape2D.position + $EnemyArea3.position
		var sizeColl = $EnemyArea3/CollisionShape2D.shape.extents
		var x = (randi() % int(sizeColl.x)) - int((sizeColl.x/2)) + int(centerpos.x)
		var y = (randi() % int(sizeColl.y)) - int((sizeColl.y/2)) + int(centerpos.y)
		
		var newEnemy = ENEMY3.instance()
		get_node("/root/LevelTemplete").add_child(newEnemy)
		newEnemy.global_position.x = x
		newEnemy.global_position.y = y
		
		Globals.list_enemy3.push_back(newEnemy)


func _on_Portal_body_entered(body):
	if body.name == "Player":
		body.global_position.x = Globals.house_position[0]
		body.global_position.y = Globals.house_position[1]+60
		pass
	pass # Replace with function body.
