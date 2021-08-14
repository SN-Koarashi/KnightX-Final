extends "res://src/Actor/Actor.gd"

var entered = false
var enter_time = 0
var reset_time = 0
var hp = 3

func _ready():
	get_node("Timer").start(1)

func _on_Area2D_area_entered(area):
	if area.name == "AttackArea":
		entered = true
func _on_Area2D_area_exited(area):
	if area.name == "AttackArea":
		entered = false

func _process(delta):
	if entered:
		enter_time += 1
		
	if enter_time >= 40:
		if Globals.hasAxe:
			hp -= 2
		else:
			hp -= 1
		enter_time = 0
		
	if hp <= 0:
		$Tree.set_frame(1)
		reset_time += 1
		
	if reset_time == 1:
		$Node2D/Label.text = "Wood +15"
		$Popup.set_current_animation("wood")
		$Popup.play()
		$down.play()
		Globals.inventory[0][0] = Globals.inventory[0][0]+15
		$Shadow1.hide()
		$Shadow2.show()
		
	if reset_time >= 540:
		hp = 3
		$Tree.set_frame(0)
		reset_time = 0
		$Shadow1.show()
		$Shadow2.hide()


func _on_Timer_timeout():
	$down.volume_db = Globals.effect_sound
