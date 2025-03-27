# Login.gd
extends Control

# 节点引用
@onready var username_input = $VBoxContainer/UsernameInput
@onready var password_input = $VBoxContainer/PasswordInput
@onready var status_label = $VBoxContainer/StatusLabel

# 模拟数据库中的用户数据
var mock_database = {
	"admin": "password123",
	"user1": "123456"
}

func _ready():
	if not is_inside_tree():
		await tree_entered
	print("SQL注入场景已就绪")
	$VBoxContainer/LoginButton.pressed.connect(_on_login_pressed)

func _on_login_pressed():
	var username = username_input.text
	var password = password_input.text
	
	# 模拟存在漏洞的SQL查询逻辑
	var query = "SELECT * FROM users WHERE username='%s' AND password='%s'" % [username, password]
	
	# 检测是否存在SQL注入特征
	if is_sql_injection(password):
		status_label.text = "登录成功！（通过SQL注入）"
		status_label.add_theme_color_override("font_color", Color.GREEN)
		# 这里可以跳转到主场景
		return
	
	# 正常验证流程
	if mock_database.has(username) && mock_database[username] == password:
		status_label.text = "登录成功！"
		status_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		status_label.text = "用户名或密码错误"
		status_label.add_theme_color_override("font_color", Color.RED)

func is_sql_injection(input: String) -> bool:
	var regex = RegEx.new()
	# 增强版正则表达式（支持更多变体）
	regex.compile("(?i)(('\\s*OR\\s*'1'\\s*=\\s*'1')|(\\s+OR\\s+\\d+\\s*=\\s*\\d+)|(--)|(\\/\\*)|(\\bUNION\\b))")
	return regex.search(input) != null

func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/cmd/cmd.tscn")
