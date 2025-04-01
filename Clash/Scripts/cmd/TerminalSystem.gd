extends Node

# 文件系统节点结构
class FileSystemNode:
	var name: String
	var type: String  # dir/file/executable
	var permissions: String
	var content: String = ""
	var children: Array = []
	var theme_color: Color = Color.WHITE  # 新增主题颜色字段

var fs_root: FileSystemNode
var current_path: Array = []  # 当前路径，例如 ["home", "user"]

var current_config_path: String = ""  # 记录当前配置文件路径
#res://files/filesystem.json
# 初始化文件系统
func _ready():
	print("[1] 脚本已加载")
	load_filesystem("res://files/filesystem.json")
	print("[2] 当前路径: ", current_path)

# 加载并解析 JSON 文件系统	
func load_filesystem(path: String):
	print("[1] 正在加载文件系统:", path)
	if not FileAccess.file_exists(path):
		push_error("❌ 文件不存在！路径: ", path)
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("❌ 文件打开失败！错误码: ", FileAccess.get_open_error())
		return
	
	print("[2] 文件打开成功")
	
	var raw_data = JSON.parse_string(file.get_as_text())
	if typeof(raw_data) != TYPE_DICTIONARY:
		push_error("❌ JSON 解析失败")
		return
	
	print("[3] JSON 解析成功")
	
	fs_root = parse_node(raw_data)
	if not fs_root or fs_root.name != "/":
		push_error("❌ 根节点初始化失败")
	else:
		print("[4] 文件系统初始化完成，根目录: ", fs_root.name)

# 递归解析 JSON 节点
func parse_node(data: Dictionary) -> FileSystemNode:
	var node = FileSystemNode.new()
	node.name = data["name"]
	node.type = data["type"]
	node.permissions = data["permissions"]
	if "content" in data:
		node.content = data["content"]
	if "children" in data:
		for child_data in data["children"]:
			node.children.append(parse_node(child_data))
	return node

# 获取当前目录的 FileSystemNode
func get_current_dir() -> FileSystemNode:
	if not fs_root:
		push_error("⚠️ File system not initialized!")
		return null

	var node = fs_root
	print("🔍 Starting from root: ", node.name)
	
	for part in current_path:
		print("   ➔ Current path part: ", part)
		var found = false
		for child in node.children:
			if child.name == part:
				node = child
				found = true
				print("     ✓ Found child: ", child.name)
				break
		
		if not found:
			push_error("⛔ Path component not found: " + part)
			return null
	
	print("✔️ Final directory: ", node.name)
	return node

signal clear_requested

# 处理输入命令
func execute_command(cmd: String) -> String:
	var args = cmd.split(" ", false)
	if args.size() == 0:
		return ""
	match args[0]:
		"ls":
			return handle_ls(args)
		"cd":
			return handle_cd(args)
		"cat":
			return handle_cat(args)
		"man":
			return "Available commands: ls, cd, cat, man, clear, hack"
		"clear":
			emit_signal("clear_requested")  # 触发清除信号
			return ""  # 返回空字符串，不在终端显示内容
		"hack":
			return handle_hack(args)
		"connect":
			return handle_connect(args)
		_:
			return "Command not found: %s" % args[0]

# --- 命令实现 ---
func handle_cd(args: Array) -> String:
	if args.size() < 2:
		return "Usage: cd <path>"
	
	var target_path = resolve_path(args[1])
	if target_path.is_empty():
		return "Error: Invalid path '%s'" % args[1]
	
	# 验证最终路径
	var node = fs_root
	for part in target_path:
		var found = false
		for child in node.children:
			if child.name == part:
				node = child
				found = true
				break
		if not found:
			return "Error: Path validation failed"
	
	current_path = target_path
	return ""

func handle_ls(_args: Array) -> String:
	if not fs_root:
		return "Error: File system not initialized"
	
	var dir = get_current_dir()
	if not dir:
		return "Error: Invalid current directory"
	
	if dir.type != "dir":
		return "Error: Not a directory"
	
	var output = []
	for child in dir.children:
		output.append("%s  %s" % [child.permissions, child.name])
	
	return "\n".join(output) if not output.is_empty() else "(empty)"

# cat 命令
func handle_cat(args: Array) -> String:
	if args.size() < 2:
		return "Usage: cat <file>"
	var file_node = find_file(args[1])
	if not file_node or file_node.type != "file":
		return "Error: File not found"
	return file_node.content

enum PORTS {
	SQL = 143
}

# TerminalSystem.gd 中的 handle_hack 函数
func handle_hack(args: Array) -> String:
	if args.size() < 2:
		return "Usage: hack <port>"
	
	var port = args[1].to_int()
	G.load_hack_scene(port)
	return "Initializing port %d breach..." % port

func _deferred_scene_change(port: String) -> void:
	match port:
		"143":
			get_tree().change_scene_to_file("res://Clash/Scenes/boss/SQL.tscn")

var IPS: Array = ["1337.1337.1337.1337"]

# TerminalSystem.gd 中的 handle_hack 函数
func handle_connect(args: Array) -> String:
	if args.size() < 2:
		return "Usage: connect <IP>"
	
	var IPs = args[1]
	if(not _deferred_IP_change(IPs)):
		return "Initializing IP %s ..." % IPs
	else:
		return "Connection established. Ready for commands."

func _deferred_IP_change(IPs: String) -> bool:
	match IPs:
		"1337.1337.1337.1337":
			load_filesystem("res://files/D.json")
			return true
		"locel":
			load_filesystem("res://files/filesystem.json")
			return true
		_:
			return false

# --- 辅助函数 ---
# 解析路径（支持相对路径和绝对路径）
func resolve_path(path: String) -> Array:
	var parts = path.split("/", false)
	var new_path = current_path.duplicate()
	
	# 处理绝对路径（例如 cd /）
	if path.begins_with("/"):
		new_path = []
		# 过滤因多个斜杠产生的空字符串（例如 "//home"）
		parts = parts.filter(func(p): return not p.is_empty())
	
	# 处理路径组件
	for part in parts:
		if part == "..":
			if new_path.size() > 0:
				new_path.pop_back()
		elif part != ".":
			new_path.append(part)
	
	# 验证路径是否存在
	var node = fs_root
	var valid_path = []
	for p in new_path:
		var found = false
		for child in node.children:
			if child.name == p:
				node = child
				valid_path.append(p)
				found = true
				break
		if not found:
			print("路径组件不存在: ", p)
			return []
	return valid_path

# 查找文件
func find_file(filename: String) -> FileSystemNode:
	var dir = get_current_dir()
	for child in dir.children:
		if child.name == filename:
			return child
	return null
