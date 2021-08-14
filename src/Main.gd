extends Control


func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("music").play()

func _on_Start_pressed():
	get_tree().change_scene("res://src/Levels.tscn")


func _on_Tips_pressed():
	OS.alert("--|== 操作說明 ==>\n1. [W][A][S][D] 移動角色\n2. [SHIFT] 移動奔跑\n3. [E] 開啟背包\n4. [R] 開啟合成介面\n5. [Q] 開啟任務列表\n6. [ESC] 暫停遊戲\n7. [左鍵] 攻擊或採集\n8. [右鍵] 與建築物件進行互動","操作提示")
	pass # Replace with function body.
