extends Actor

onready var BULLET = preload("Bullet.tscn")
onready var SWORD = preload("Sword.tscn")
onready var SOUL = preload("Soul.tscn")
onready var HOUSE = preload("../house.tscn")
onready var CRYS = preload("../crystal.tscn")
onready var CHES = preload("../chest.tscn")

onready var tween = $Tween
onready var _animated_sprite = $Player

# hit from left
var hit_dir = ""
var knockback_hit_started = false
var time = 0
# resting time (count per 1/60 seconds, maybe? that mean FPS but my screen is too suck)
var AFK_counter = 0
var onWallHIt = "none"
var sword_started = false
var attacking_counter = 0
var onGUI = false
var openInvTime = 0
# equip
var hasSword = false
var hasMagic = false
var hasSoul = false
# building
var hasHouse = false
var hasChest = false
var hasCrystal = false

var buildMode = false
var building = null

var leftMode = "hand"

func _ready():
	Globals.hasPickaxe = false
	Globals.hasShear = false
	Globals.hasAxe = false
	Globals.eScore = 0
	Globals.score = 0
	Globals.time_bonus = 0
	Globals.inventory[0][0] = 0
	Globals.inventory[0][1] = 0
	Globals.inventory[0][2] = 0
	Globals.inventory_chest = [[0,0,0]]
	Globals.list_enemy1 = []
	Globals.list_enemy2 = []
	Globals.list_enemy3 = []
	Globals.house_position = [0,0]
	Globals.health = 3
	Globals.openChestMenu = false
	
	$Timer.start(1)


func _input(event):
	if !onGUI and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var dir = get_local_mouse_position().angle()
			
		if leftMode == "magic":
			$onFire.play()
			var bullet =  BULLET.instance()
			get_node("/root/LevelTemplete").add_child(bullet)
			bullet.global_position.x = $Player.global_position.x
			bullet.global_position.y = $Player.global_position.y
			
			if mouse_dir(dir) == "left":
				bullet.global_position.x = $Player.global_position.x - 40
				bullet.apply_impulse(Vector2(80,80),Vector2(-1025,0.0015))
			elif mouse_dir(dir) == "right":
				bullet.global_position.x = $Player.global_position.x + 40
				bullet.apply_impulse(Vector2(80,80),Vector2(1025,0.0015))
			elif mouse_dir(dir) == "top":
				bullet.global_position.y = $Player.global_position.y - 40
				bullet.apply_impulse(Vector2(80,80),Vector2(0.0015,-1025))
			elif mouse_dir(dir) == "bottom":
				bullet.global_position.y = $Player.global_position.y + 40
				bullet.apply_impulse(Vector2(80,80),Vector2(0.0015,1025))
			else:
				pass
		if leftMode == "soul":
			$onFire.play()
			
			
			for n in 8:
				var Soul =  SOUL.instance()
				get_node("/root/LevelTemplete").add_child(Soul)
				Soul.global_position.x = $Player.global_position.x
				Soul.global_position.y = $Player.global_position.y
				
				if n == 0:
					Soul.global_position.x = $Player.global_position.x - 65
					Soul.apply_impulse(Vector2(80,80),Vector2(-1025,0))
				elif n == 1:
					Soul.global_position.x = $Player.global_position.x - 65
					Soul.global_position.y = $Player.global_position.y - 65
					Soul.apply_impulse(Vector2(80,80),Vector2(-1025,-1025))
				elif n == 2:
					Soul.global_position.y = $Player.global_position.y - 65
					Soul.apply_impulse(Vector2(80,80),Vector2(0,-1025))
				elif n == 3:
					Soul.global_position.x = $Player.global_position.x + 65
					Soul.global_position.y = $Player.global_position.y - 65
					Soul.apply_impulse(Vector2(80,80),Vector2(1025,-1025))
				elif n == 4:
					Soul.global_position.x = $Player.global_position.x + 65
					Soul.apply_impulse(Vector2(80,80),Vector2(1025,0))
				elif n == 5:
					Soul.global_position.x = $Player.global_position.x + 65
					Soul.global_position.y = $Player.global_position.y + 65
					Soul.apply_impulse(Vector2(80,80),Vector2(1025,1025))
				elif n == 6:
					Soul.global_position.y = $Player.global_position.y + 65
					Soul.apply_impulse(Vector2(80,80),Vector2(0.0015,1025))
				elif n == 7:
					Soul.global_position.x = $Player.global_position.x - 65
					Soul.global_position.y = $Player.global_position.y + 65
					Soul.apply_impulse(Vector2(80,80),Vector2(-1025,1025))
			
				
		if leftMode == "sword" and !sword_started:
			$attackEffect.play()
			var sword =  SWORD.instance()
			get_node("/root/LevelTemplete").add_child(sword)
			sword.global_position.x = $Player.global_position.x
			sword.global_position.y = $Player.global_position.y
			
			if mouse_dir(dir) == "left":
				sword.global_position.x = $Player.global_position.x - 30
				sword.apply_impulse(Vector2(0,0),Vector2(-80,0.0015))
			elif mouse_dir(dir) == "right":
				sword.global_position.x = $Player.global_position.x + 30
				sword.apply_impulse(Vector2(0,0),Vector2(80,0.0015))
			elif mouse_dir(dir) == "top":
				sword.global_position.y = $Player.global_position.y - 30
				sword.apply_impulse(Vector2(0,0),Vector2(0.0015,-80))
			elif mouse_dir(dir) == "bottom":
				sword.global_position.y = $Player.global_position.y + 30
				sword.apply_impulse(Vector2(0,0),Vector2(0.0015,80))
			else:
				pass
			
			sword_started = true
			$SwordTimer.start(1.5)
			
		if !$Attack.is_playing() and leftMode == "hand":
			$Attack/AttackArea.scale.x = 1
			$Attack/AttackArea.scale.y = 1
			
			if mouse_dir(dir) == "left":
				$Attack.position.x = -50
				$Attack.play()
			elif mouse_dir(dir) == "right":
				$Attack.position.x = 50
				$Attack.set_flip_h(true)
				$Attack.play()
			elif mouse_dir(dir) == "top":
				$Attack.position.y = -68
				$Attack.play("default",true)
			elif mouse_dir(dir) == "bottom":
				$Attack.position.y = 32
				$Attack.set_flip_h(true)
				$Attack.set_flip_v(true)
				$Attack.play("default",true)
			else:
				pass
			$attackEffect.play()
	
	if onGUI and buildMode:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			#print(get_global_mouse_position())
			#building.get_node(building.name).get_parent().get_node("hitbox").disabled = false
			#building.get_node(building.name).get_parent().get_node("Area2D/hitbox").disabled = false
			if building != null:
				if building.get_node(building.name).get_parent().get_node("check").get_overlapping_areas().size() == 1:
					if building.name == "house":
						if building.get_node(building.name).get_parent().get_node("check").get_overlapping_areas()[0].name == "WorldArea":
							building.get_node(building.name).get_parent().get_node("hitbox").disabled = false
							building.get_node(building.name).get_parent().get_node("Area2D/hitbox").disabled = false
							building.get_node(building.name).get_parent().get_node("check/hitbox").disabled = true
							building.get_node(building.name).get_parent().z_index = 5
							
							Globals.house_position = [get_global_mouse_position().x,get_global_mouse_position().y]
							building = null
							onGUI = false
							buildMode = false
						else:
							$Not/Notice.text = "[!] Please build central the world."
							$NoticeTimer.start(2)
					else:
						if building.get_node(building.name).get_parent().get_node("check").get_overlapping_areas()[0].name == "HouseArea":
							building.get_node(building.name).get_parent().get_node("hitbox").disabled = false
							building.get_node(building.name).get_parent().z_index = 5
							
							building = null
							onGUI = false
							buildMode = false
						else:
							$Not/Notice.text = "[!] Please build central the house."
							$NoticeTimer.start(2)
				elif building.get_node(building.name).get_parent().get_node("check").get_overlapping_areas().size() > 1:
					$Not/Notice.text = "[!] Please build in open space."
					$NoticeTimer.start(2)
				else:
					$Not/Notice.text = "[!] Please build inside the world."
					$NoticeTimer.start(2)
			pass
		
	if Input.is_action_pressed("openInv") and openInvTime >= 15:
		if $Camera2D/invMneu.visible:
			$Camera2D/invMneu.visible = false
			openInvTime = 0
		else:
			$Camera2D/invMneu.visible = true
			$guiEffect.play()
			openInvTime = 0
			
	if Input.is_action_pressed("craft") and openInvTime >= 15:
		if $Camera2D/craftMenu.visible:
			$Camera2D/craftMenu.visible = false
			openInvTime = 0
			onGUI = false
		else:
			$Camera2D/craftMenu.visible = true
			$guiEffect.play()
			openInvTime = 0
			onGUI = true
	if Input.is_action_pressed("mission") and openInvTime >= 15:
		if $Camera2D/Mission.visible:
			$Camera2D/Mission.visible = false
			openInvTime = 0
			onGUI = false
		else:
			$Camera2D/Mission.visible = true
			$guiEffect.play()
			openInvTime = 0
			onGUI = true
			
	if Input.is_action_pressed("esc"):
		if $Camera2D/escMenu.visible:
			$Camera2D/escMenu.visible = false
			onGUI = false
			get_tree().paused = false
		else:
			$Camera2D/escMenu.visible = true
			onGUI = true
			get_tree().paused = true
			$guiEffect.play()
	
	if Input.is_action_pressed("hand"):
		leftMode = "hand"
		$Not/Notice.text = "[!] Change weapon to your hand successfully."
		$NoticeTimer.start(2)
	elif Input.is_action_pressed("sword"):
		if hasSword:
			$Not/Notice.text = "[!] Change weapon to Short Darts successfully."
			$NoticeTimer.start(2)
			leftMode = "sword"
		else:
			$Not/Notice.text = "[!] You need to craft Short Darts weapon first."
			$NoticeTimer.start(2)
	elif Input.is_action_pressed("magic"):
		if hasMagic:
			$Not/Notice.text = "[!] Change weapon to Magic Fire successfully."
			$NoticeTimer.start(2)
			leftMode = "magic"
		else:
			$Not/Notice.text = "[!] You need to craft Magic Fire weapon first."
			$NoticeTimer.start(2)
	elif Input.is_action_pressed("soul"):
		if hasSword:
			$Not/Notice.text = "[!] Change weapon to Soul Explosion successfully."
			$NoticeTimer.start(2)
			leftMode = "soul"
		else:
			$Not/Notice.text = "[!] You need to craft Soul Explosion weapon first."
			$NoticeTimer.start(2)
	
	
func _physics_process(delta: float) -> void:
	var dir: = get_dir()
	vel = calcu_move_vel(vel,dir,speed)
	vel = move_and_slide_with_snap(vel, Vector2.ZERO)

func _process(delta):
	# chest menu
	if !$Camera2D/chestMenu.visible and Globals.openChestMenu:
		$Camera2D/chestMenu/wdbar.value = 0
		$Camera2D/chestMenu/stbar.value = 0
		$Camera2D/chestMenu/rpbar.value = 0
		$Camera2D/chestMenu/wdbar.editable = false
		$Camera2D/chestMenu/stbar.editable = false
		$Camera2D/chestMenu/rpbar.editable = false
		$Camera2D/chestMenu/CheckBox.disabled = true
		$Camera2D/chestMenu/CheckBox.pressed = false
		
		var wood = Globals.inventory[0][0]
		var stone = Globals.inventory[0][1]
		var rope = Globals.inventory[0][2]
		if wood > 0:
			$Camera2D/chestMenu/wdbar.editable = true
			$Camera2D/chestMenu/wdbar.max_value = wood
		if stone > 0:
			$Camera2D/chestMenu/stbar.editable = true
			$Camera2D/chestMenu/stbar.max_value = stone
		if rope > 0:
			$Camera2D/chestMenu/rpbar.editable = true
			$Camera2D/chestMenu/rpbar.max_value = rope
		
		if Globals.inventory_chest[0][0] > 0 or Globals.inventory_chest[0][1] > 0 or Globals.inventory_chest[0][2] > 0:
			$Camera2D/chestMenu/CheckBox.disabled = false
		
		$Camera2D/chestMenu.visible = true
		onGUI = true
	
	#build mode !!
	if buildMode and building != null:
		building.global_position = get_global_mouse_position()
		
	if buildMode:
		$Camera2D/BDMode.visible = true
	else:
		$Camera2D/BDMode.visible = false
	
	# uhhhhh?
	if openInvTime >= 600:
		openInvTime = 0
	openInvTime += 1

	# mouse attack
	if $Attack.is_playing():
		attacking_counter += 1
	if attacking_counter >= 45:
		$Attack/AttackArea.scale.x = 0.2
		$Attack/AttackArea.scale.y = 0.2
		$Attack.position.x = 0
		$Attack.position.y = -18
		$Attack.set_flip_h(false)
		$Attack.set_flip_v(false)
		$Attack.stop()
		$Attack.set_frame(0)
		attacking_counter = 0

	if !Globals.openChestMenu:
		# eight dir moveing
		if Input.is_action_pressed("move_right"):
			_animated_sprite.set_animation("right")
			_animated_sprite.play()
		elif Input.is_action_pressed("move_left"):
			_animated_sprite.set_animation("left")
			_animated_sprite.play()
		elif Input.is_action_pressed("move_top"):
			_animated_sprite.set_animation("top")
			_animated_sprite.play()
		elif Input.is_action_pressed("move_down"):
			_animated_sprite.set_animation("down")
			_animated_sprite.play()
		else:
			_animated_sprite.stop()
			_animated_sprite.set_frame(1)
		
	# she is running!
	if Input.is_action_pressed("running"):
		speed = Vector2(475.0,475.0)
	else:
		speed = Vector2(275.0,275.0)

	# when player resting
	if vel == Vector2.ZERO:
		AFK_counter += 1
	else:
		AFK_counter = 0
	# Unstock, Restart game
	if Input.get_action_strength("Reflash") and AFK_counter > 30:
		AFK_counter = 0
		get_node("CollisionShape2D").disabled = true
		queue_free()
		get_tree().reload_current_scene()
	
	# Player Knockback by Enemy
	if knockback_hit_started:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider is TileMap or collision.collider is StaticBody2D:
				if collision.normal.x > 0 and collision.normal.y == 0:
					onWallHIt = "left"
				elif collision.normal.x < 0 and collision.normal.y == 0:
					onWallHIt = "right"
				elif collision.normal.x == 0 and collision.normal.y < 0:
					onWallHIt = "bottom"
				elif collision.normal.x == 0 and collision.normal.y > 0:
					onWallHIt = "top"
				else:
					onWallHIt = "none"
			
		if(hit_dir == "left"):
			tween.interpolate_property(self, "position",
					position, Vector2(position.x-150 ,position.y), 0.25,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			get_node("Knockback").play()
			hit_dir = ""
		elif(hit_dir == "right"):
			tween.interpolate_property(self, "position",
					position, Vector2(position.x+150 ,position.y), 0.25,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			get_node("Knockback").play()
			hit_dir = ""
		elif(hit_dir == "top"):
			tween.interpolate_property(self, "position",
					position, Vector2(position.x ,position.y-150), 0.25,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			get_node("Knockback").play()
			hit_dir = ""
		elif(hit_dir == "bottom"):
			tween.interpolate_property(self, "position",
					position, Vector2(position.x ,position.y+150), 0.25,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			get_node("Knockback").play()
			hit_dir = ""
			
		if onWallHIt != "none":
			tween.stop(self)
			onWallHIt = "none"
		if not tween.is_active():
			knockback_hit_started = false
	# when counter more than 600, it need to reset to 0 because ...?
	if(AFK_counter > 600):
		AFK_counter = 0
func _on_Area2D_body_entered(body: PhysicsBody2D):
	# HITBOX, my love!
	if body.name == "Boss":
		minusHP(body, get_node("Area2D"), "Boss")
	else:
		minusHP(body, get_node("Area2D"), "Enemy")
		
func mouse_dir(mouse_dir: float) -> String:
	if mouse_dir > -1 and mouse_dir < 1:
		return "right"
		#print("mouse_dir: right")
	elif mouse_dir > -4 and mouse_dir < -2 or mouse_dir > 2 and mouse_dir < 4:
		#print("mouse_dir: left")
		return "left"
	elif mouse_dir > -2 and mouse_dir < -1:
		#print("mouse_dir: top")
		return "top"
	elif mouse_dir > 1 and mouse_dir < 2:
		#print("mouse_dir: bottom")
		return "bottom"
	else:
		return "none"
# idk
func minusHP(entity: PhysicsBody2D, PArea2D: Node2D, DamagedFrom: String) -> void:
	# oh sad, the health minus one
	
	if DamagedFrom == "Boss":
		Globals.health -= 3
	else:
		Globals.health -= 1
	
	if DamagedFrom != "Trap":
		var diff_x = (entity.global_position.x - PArea2D.global_position.x)
		var diff_y = (entity.global_position.y - PArea2D.global_position.y)
		var original_size = entity.get_node('CollisionShape2D').shape.extents*2
		
		if abs(diff_x) > original_size.x: #right or left
			if diff_x > 0:
				hit_dir = "left"
			else:
				hit_dir = "right"
		elif abs(diff_y) > original_size.y: # top or bottom
			if diff_y > 0:
				hit_dir = "top"
			else:
				hit_dir = "bottom"
		knockback_hit_started = true
		
		#print(entity.global_position.x)
		# Call player knockback func
		#if(entity.x < PArea2D.global_position.x):
		#	hit_dir = "left"
		#	knockback_hit_started = true
		#else:
		#	hit_dir = "right"
		#	knockback_hit_started = true
	
	# when health less than 0, restarting game
	# hide health images?
	if(Globals.health <= 0):
		$Camera2D/Health/hp1.hide()
		get_node("Knockback").play()
		queue_free()
		get_tree().change_scene("res://src/GameOver.tscn")
	elif Globals.health == 2:
		$Camera2D/Health/hp3.hide()
	elif Globals.health == 1:
		$Camera2D/Health/hp2.hide()
				
func get_dir() -> Vector2:
	if Globals.openChestMenu:
		return Vector2.ZERO
	else:
		return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_top")
		)
func calcu_move_vel(liner_vel: Vector2,dir: Vector2,speed: Vector2) -> Vector2:
	var new_vel: = liner_vel
	new_vel.x = speed.x * dir.x
	new_vel.y = speed.y * dir.y
	return new_vel

func _on_Timer_timeout():
	$attackEffect.volume_db = Globals.effect_sound
	$Knockback.volume_db = Globals.effect_sound
	$onFire.volume_db = Globals.effect_sound
	$Camera2D/invMneu/wood.text = str(Globals.inventory[0][0])
	$Camera2D/invMneu/stone.text = str(Globals.inventory[0][1])
	$Camera2D/invMneu/rope.text = str(Globals.inventory[0][2])
	
	time += 1
	var time_min = floor(time/60)
	var time_min_format = "0" + str(time_min) if time_min < 10 else str(time_min)
	
	var time_sec = time - floor(time/60)*60
	var time_sec_format = "0" + str(time_sec) if time_sec < 10 else str(time_sec)
	

	$Camera2D/Label2.text = time_min_format + ":" + time_sec_format

	if Globals.inventory[0][0] >= 100:
		$Camera2D/Mission/wd.pressed = true
	else:
		$Camera2D/Mission/wd.pressed = false
	if Globals.inventory[0][1] >= 100:
		$Camera2D/Mission/st.pressed = true
	else:
		$Camera2D/Mission/st.pressed = false
	if Globals.inventory[0][2] >= 100:
		$Camera2D/Mission/rp.pressed = true
	else:
		$Camera2D/Mission/rp.pressed = false

	if Globals.eScore >= 15:
		$Camera2D/Mission/ene.pressed = true
		
	if Globals.hasPickaxe and Globals.hasAxe and Globals.hasShear and hasChest and hasCrystal and hasHouse and hasMagic and hasSoul and hasSword:
		$Camera2D/Mission/craft.pressed = true
	
	if $Camera2D/Mission/wd.pressed and $Camera2D/Mission/st.pressed and $Camera2D/Mission/rp.pressed and $Camera2D/Mission/ene.pressed and $Camera2D/Mission/craft.pressed:
		$Camera2D/Mission/Button.disabled = false
	else:
		$Camera2D/Mission/Button.disabled = true
	
	
	# show health images?
	if Globals.health == 3:
		$Camera2D/Health/hp3.show()
		$Camera2D/Health/hp2.show()
	
	#if get_node("/root/LevelTemplete/Boss") == null:
	#	get_node("Timer").stop()
	#	var time_bonus = Globals.base_score - time
	#	var score = Globals.eScore + time_bonus

	#	Globals.score = score
	#	Globals.time_format = $Camera2D/Label2.text
	#	Globals.time_bonus = time_bonus
	#	
	#	get_tree().change_scene("res://src/GameWin.tscn")
		

func _on_continue_pressed():
	$Camera2D/escMenu.visible = false
	onGUI = false
	get_tree().paused = false


func _on_musicSound_value_changed(value):
	Globals.music_sound = value

func _on_effectSound_value_changed(value):
	Globals.effect_sound = value


func _on_pickaxe_pressed():
	if Globals.inventory[0][0] >= 10 and Globals.inventory[0][1] >= 20:
		Globals.hasPickaxe = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 10
		Globals.inventory[0][1] = Globals.inventory[0][1] - 20
		$Camera2D/craftMenu/toolsM/pickaxe.disabled = true
	else:
		OS.alert("你沒有足夠的物資來合成這項道具","Game message")


func _on_shear_pressed():
	if Globals.inventory[0][0] >= 10 and Globals.inventory[0][1] >= 15:
		Globals.hasShear = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 10
		Globals.inventory[0][1] = Globals.inventory[0][1] - 15
		$Camera2D/craftMenu/toolsM/shear.disabled = true
	else:
		OS.alert("你沒有足夠的物資來合成這項道具","Game message")


func _on_axe_pressed():
	if Globals.inventory[0][0] >= 10 and Globals.inventory[0][1] >= 25:
		Globals.hasAxe = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 10
		Globals.inventory[0][1] = Globals.inventory[0][1] - 25
		$Camera2D/craftMenu/toolsM/axe.disabled = true
	else:
		OS.alert("你沒有足夠的物資來合成這項道具","Game message")


func _on_house_pressed():
	if Globals.inventory[0][0] >= 300 and Globals.inventory[0][1] >= 300 and Globals.inventory[0][2] >= 120:
		hasHouse = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 300
		Globals.inventory[0][1] = Globals.inventory[0][1] - 300
		Globals.inventory[0][2] = Globals.inventory[0][2] - 120
		$Camera2D/craftMenu/buildingM/house.disabled = true
		$Camera2D/craftMenu.visible = false
		buildMode = true
		building = HOUSE.instance()
		get_node("/root/LevelTemplete").add_child(building)
	else:
		OS.alert("你沒有足夠的物資來建造","Game message")


func _on_NoticeTimer_timeout():
	$Not/Notice.text = ""
	$NoticeTimer.stop()


func _on_crystal_pressed():
	if Globals.inventory[0][2] >= 300 and hasHouse:
		hasCrystal = true
		Globals.inventory[0][2] = Globals.inventory[0][2] - 300
		$Camera2D/craftMenu.visible = false
		$Camera2D/craftMenu/buildingM/crystal.disabled = true
		buildMode = true
		building = CRYS.instance()
		get_node("/root/LevelTemplete").add_child(building)
	elif !hasHouse:
		OS.alert("你需要先建造一間房子","Game message")
	else:
		OS.alert("你沒有足夠的物資來建造","Game message")


func _on_chest_pressed():
	if Globals.inventory[0][0] >= 100 and Globals.inventory[0][2] >= 50 and hasHouse:
		hasChest = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 100
		Globals.inventory[0][2] = Globals.inventory[0][2] - 50
		$Camera2D/craftMenu.visible = false
		$Camera2D/craftMenu/buildingM/chest.disabled = true
		buildMode = true
		building = CHES.instance()
		get_node("/root/LevelTemplete").add_child(building)
	elif !hasHouse:
		OS.alert("你需要先建造一間房子","Game message")
	else:
		OS.alert("你沒有足夠的物資來建造","Game message")


func _on_close_pressed():
	$Camera2D/chestMenu.visible = false
	onGUI = false
	Globals.openChestMenu = false


func _on_done_pressed():
	if $Camera2D/chestMenu/CheckBox.pressed: # 領出來
		Globals.inventory_chest[0][0] -= $Camera2D/chestMenu/wdbar.value
		Globals.inventory_chest[0][1] -= $Camera2D/chestMenu/stbar.value
		Globals.inventory_chest[0][2] -= $Camera2D/chestMenu/rpbar.value
		
		Globals.inventory[0][0] += $Camera2D/chestMenu/wdbar.value
		Globals.inventory[0][1] += $Camera2D/chestMenu/stbar.value
		Globals.inventory[0][2] += $Camera2D/chestMenu/rpbar.value
	else:
		Globals.inventory_chest[0][0] += $Camera2D/chestMenu/wdbar.value
		Globals.inventory_chest[0][1] += $Camera2D/chestMenu/stbar.value
		Globals.inventory_chest[0][2] += $Camera2D/chestMenu/rpbar.value
		
		Globals.inventory[0][0] -= $Camera2D/chestMenu/wdbar.value
		Globals.inventory[0][1] -= $Camera2D/chestMenu/stbar.value
		Globals.inventory[0][2] -= $Camera2D/chestMenu/rpbar.value
	$Camera2D/chestMenu.visible = false
	Globals.openChestMenu = false
	onGUI = false

func _on_CheckBox_pressed():
	$Camera2D/chestMenu/wdbar.value = 0
	$Camera2D/chestMenu/stbar.value = 0
	$Camera2D/chestMenu/rpbar.value = 0
	$Camera2D/chestMenu/wdbar.editable = false
	$Camera2D/chestMenu/stbar.editable = false
	$Camera2D/chestMenu/rpbar.editable = false
	if $Camera2D/chestMenu/CheckBox.pressed: #領取模式
		var wood = Globals.inventory_chest[0][0]
		var stone = Globals.inventory_chest[0][1]
		var rope = Globals.inventory_chest[0][2]
		if wood > 0:
			$Camera2D/chestMenu/wdbar.editable = true
			$Camera2D/chestMenu/wdbar.max_value = wood
		if stone > 0:
			$Camera2D/chestMenu/stbar.editable = true
			$Camera2D/chestMenu/stbar.max_value = stone
		if rope > 0:
			$Camera2D/chestMenu/rpbar.editable = true
			$Camera2D/chestMenu/rpbar.max_value = rope
	else:
		var wood = Globals.inventory[0][0]
		var stone = Globals.inventory[0][1]
		var rope = Globals.inventory[0][2]
		if wood > 0:
			$Camera2D/chestMenu/wdbar.editable = true
			$Camera2D/chestMenu/wdbar.max_value = wood
		if stone > 0:
			$Camera2D/chestMenu/stbar.editable = true
			$Camera2D/chestMenu/stbar.max_value = stone
		if rope > 0:
			$Camera2D/chestMenu/rpbar.editable = true
			$Camera2D/chestMenu/rpbar.max_value = rope
	pass # Replace with function body.


func _on_tips_pressed():
	OS.alert("--|== 過關條件 ===>\n1.採集並擁有一定數量的資源\n2.製造出所有可製造的道具及建築\n3.擊殺至少15名敵人\n\n--|== 遊戲機制 ===>\n晚上會重生所有已死亡的敵人，你可以建造房屋並待在裡面以度過夜晚；\n箱子可儲存採集到的資源；水晶能夠回復全部的生命值。\n箱子及水晶只能夠建造在屋內。\n遊戲第一天白天不會重生怪物，晚上才會開始有敵人，請把握時間。\n敵人的重生區域為地圖的上半部及下半部。\n遊戲的白天時長為120秒；晚上為90秒。\n\n--|== 物品說明 ===>\n1.製作工具能夠有效提升採集效率\n2.製作武器能夠讓你更輕易地對付敵人\n3.工具只能夠在手模式使用\n4.各個武器都需要使用按鍵切換方可使用\n5.模式切換由鍵盤上的 1~4 分別代表著 手、短型飛鏢、魔法火球、靈魂爆破\n6.手模式仍然能夠激怒敵人，但你無法對他造成傷害；即便那個動畫看起來傷害不小","Game Tips")
	pass # Replace with function body.


func _on_magic_pressed():
	if Globals.inventory[0][0] >= 200 and Globals.inventory[0][1] >= 200 and Globals.inventory[0][2] >= 300 and hasSword:
		hasMagic = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 200
		Globals.inventory[0][1] = Globals.inventory[0][1] - 200
		Globals.inventory[0][2] = Globals.inventory[0][2] - 300
		$Camera2D/craftMenu/weaponM/magic.disabled = true
	elif !hasSword:
		OS.alert("你需要先製作一把短型飛鏢","Game message")
	else:
		OS.alert("你沒有足夠的物資來製作這個武器","Game message")


func _on_sword_pressed():
	if Globals.inventory[0][0] >= 25 and Globals.inventory[0][1] >= 50 and Globals.inventory[0][2] >= 15:
		hasSword = true
		Globals.inventory[0][0] = Globals.inventory[0][0] - 25
		Globals.inventory[0][1] = Globals.inventory[0][1] - 50
		Globals.inventory[0][2] = Globals.inventory[0][2] - 15
		$Camera2D/craftMenu/weaponM/sword.disabled = true
	else:
		OS.alert("你沒有足夠的物資來製作這個武器","Game message")


func _on_soul_pressed():
	if Globals.inventory[0][0] >= 400 and Globals.inventory[0][1] >= 400 and Globals.inventory[0][2] >= 600 and hasMagic:
		hasSoul = true
		onGUI = false
		Globals.inventory[0][0] = Globals.inventory[0][0] - 400
		Globals.inventory[0][1] = Globals.inventory[0][1] - 400
		Globals.inventory[0][2] = Globals.inventory[0][2] - 600
		$Camera2D/craftMenu/weaponM/soul.disabled = true
	elif !hasMagic:
		OS.alert("你需要先製作一個魔法火球","Game message")
	else:
		OS.alert("你沒有足夠的物資來製作這個武器","Game message")


func _on_SwordTimer_timeout():
	sword_started = false
	$SwordTimer.stop()


func _on_help_pressed():
	OS.alert("--|== 操作說明 ==>\n1. [W][A][S][D] 移動角色\n2. [SHIFT] 移動奔跑\n3. [E] 開啟背包\n4. [R] 開啟合成介面\n5. [Q] 開啟任務列表\n6. [ESC] 暫停遊戲\n7. [左鍵] 攻擊或採集\n8. [右鍵] 與建築物件進行互動","操作提示")


func _on_exit_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_RIGHT:
				get_tree().quit()

func _on_exit_pressed():
	OS.alert("為了防止你誤觸這個按鈕，你必須對按鈕按下右鍵才能關閉遊戲","WARN")


func _on_Button_pressed():
	get_node("Timer").stop()
	var time_bonus = Globals.eScore*120+Globals.inventory[0][0]+Globals.inventory[0][1]+Globals.inventory[0][2] - time
	var time_bonus_chest = Globals.inventory_chest[0][0]+Globals.inventory_chest[0][1]+Globals.inventory_chest[0][2]
	var score = Globals.eScore + time_bonus
	Globals.score = score
	Globals.time_format = $Camera2D/Label2.text
	Globals.time_bonus = time_bonus + int(time_bonus_chest * 1.5)
		
	get_tree().change_scene("res://src/GameWin.tscn")
