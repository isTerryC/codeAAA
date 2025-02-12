extends Control


@onready var progress_bar = $ProgressBar  # 获取进度条节点
@onready var label : Label = $percentage  # 获取标签节点，确保它是 Label 类型
@onready var status_label : Label = $MarginContainer/Loading_Content
@onready var percentage : Label = $percentage


func _ready():
	# 检查 Label 是否存在
	if label:
		# 初始化进度条
		progress_bar.value = 0  # 确保进度条从 0 开始
		progress_bar.max_value = 100  # 设置进度条的最大值为 100
		
		status_label.text = "正在登入..."  #设置初始文字

		# 模拟加载过程
		for i in range(73):  # 从 0 到 100
			progress_bar.value = i  # 更新进度条的当前值
			label.text = str(i) + "%"  # 更新标签显示的百分比
			#根据进度改变文字内容
			if i > 0 and i<= 50:
				status_label.text = "正在登入..."
				await get_tree().create_timer(0.05).timeout
			elif i>50 and i<69:
				status_label.text = "过程中出现意外错误"
				status_label.modulate=Color(1,0,0,1)
				
				var newStyle = $ProgressBar.get_theme_stylebox("fill").duplicate()
				newStyle.bg_color=Color(0.545098, 0, 0, 1)
				progress_bar.add_theme_stylebox_override("fill",newStyle)
				
				await get_tree().create_timer(0.2).timeout
			elif i>69 and i<72:
				status_label.text = "系统将在5秒之后重启"
				percentage.modulate = Color(1,0,0,1)
				await get_tree().create_timer(0.2).timeout
		
		for i in range(5):
			var last_time : int = 4 - i
			status_label.text = "系统将在"+ str(last_time) +"秒之后重启"
			await get_tree().create_timer(0.3).timeout
			status_label.text = "过程中出现意外错误"
			await get_tree().create_timer(0.7).timeout
		
		# 加载完成后，切换到主游戏场景
		#var main_scene = load("res://MainScene.tscn")  # 加载主场景资源
		get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0/initialize.tscn")  # 使用 change_scene_to 替换 change_scene
	else:
		print("Label node not found!")
  # 替换为你主场景的路径
