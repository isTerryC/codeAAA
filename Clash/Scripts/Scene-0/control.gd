extends BaseGUIView

func _ready() -> void: #运行前
	#开始检测按钮状态
	set_process_input(true)

#处理选择
#按下 1 按钮
func _on_button_wakeup_pressed() -> void:
	start_game() #开始新的游戏

#按下 2 按钮	
func _on_button_continue_pressed() -> void:
	print("进入设置")

#按下 3 按钮
func _on_button_exit_pressed() -> void:
	get_tree().quit() #退出游戏


func start_game():
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0/loading.tscn")  # 切换到游戏场景
