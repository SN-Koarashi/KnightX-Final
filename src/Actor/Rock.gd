extends "res://src/Actor/Actor.gd"

var entered = false;
var enter_time = 0
var reset_time = 0
var hp = 5

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
		if Globals.hasPickaxe:
			hp -= 2
		else:
			hp -= 1
		enter_time = 0
		
	if hp <= 0:
		$rock.set_frame(2)
		reset_time += 1
	if hp == 2:
		$rock.set_frame(1)
		
	if reset_time == 1:
		$Node2D/Label.text = "Stone +8"
		$Popup.set_current_animation("wood")
		$Popup.play()
		$down.play()
		Globals.inventory[0][1] = Globals.inventory[0][1]+8
		
	if reset_time >= 540:
		hp = 5
		$rock.set_frame(0)
		reset_time = 0


func _on_Timer_timeout():
	$down.volume_db = Globals.effect_sound
