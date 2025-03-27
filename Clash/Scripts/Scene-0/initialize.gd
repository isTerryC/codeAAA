extends Control
#初始化(Loading_Content)->选项(VboxContainer)->选项1->检测到错误，启动自检(Label_Warning)->选项2->请不要关闭你的终端(Label_Warning)->新场景(newLoading.tscn)

func _ready():
	set_process_input(true)
	var label_l = $MarginContainer/Loading_Content
	var label_w = $MarginContainer2/Label_Warning
	var button = $MarginContainer2/VBoxContainer
	
	label_l.text="正在初始化..."
	label_w.visible = false
	button.visible = false
	
	await create_timer_and_wait(1.5)
	
	label_l.text=""
	button.visible = true

	
func _on_button_1_pressed() -> void:
	var label_w = $MarginContainer2/Label_Warning
	var button = $MarginContainer2/VBoxContainer
	label_w.text = "检测到先前的启动错误，正在进入启动自检程序\n请不要关闭您的终端..."
	button.visible = false
	label_w.visible = true
	await create_timer_and_wait(2.2)
	label_w.text = "正在进入安全模式\n请不要关闭您的终端..."
	await create_timer_and_wait(3.0)
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0/newloading.tscn")
	

func _on_button_2_pressed() -> void:
	var label_w = $MarginContainer2/Label_Warning
	var button = $MarginContainer2/VBoxContainer
	button.visible = false
	label_w.visible = true
	label_w.text = "正在进入安全模式\n请不要关闭您的终端..."
	await create_timer_and_wait(3.0)
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0/newloading.tscn")
	
func create_timer_and_wait(timeout: float):
	
	var timer = get_tree().create_timer(timeout)
	await timer.timeout
	
