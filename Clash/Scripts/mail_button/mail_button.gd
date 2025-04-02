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
	# 自动收集所有Mail节点（支持任意数量）
	var mail_nodes = []
	var i = 1
	while true:
		var node = get_node_or_null("Mail_%02d" % i)
		if node:
			mail_nodes.append(node)
			i += 1
		else:
			break
	
	# 确保flag在有效范围内
	var max_flag = mail_nodes.size() - 1
	var safe_flag = clamp(flag, 0, max_flag)
	
	# 使用循环设置可见性
	for index in mail_nodes.size():
		mail_nodes[index].visible = (index <= safe_flag)
		
func _hide_buttons(container: Node) -> void:
	for node in container.get_children():
		# 如果是按钮，隐藏它
		if (node.get_class()=="Button"):
			node.visible = false
