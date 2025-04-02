extends Node

func _ready() -> void:
	# 获取 G.gd 脚本的实例
	var g_script = get_node("/root/G")
	
	# 连接 G.gd 的信号
	g_script.flag_changed.connect(_on_flag_changed)
	
	# 初始隐藏所有按钮
	_hide_buttons($".")


func _on_flag_changed() -> void:
	# 获取 G.gd 脚本的实例
	var g_script = get_node("/root/G")
	
	# 根据 flag 的值更新按钮的可见性
	_changeVisibility(g_script.flag)

func _changeVisibility(flag: int) -> void:
	if (flag == 0):
		$Mail_01.visible = true
		$Mail_02.visible = false
	elif (flag == 1):
		$Mail_01.visible = false
		$Mail_02.visible = true
		
func _hide_buttons(container: Node) -> void:
	for node in container.get_children():
		# 如果是按钮，隐藏它
		if (node.get_class()=="Button"):
			node.visible = false
