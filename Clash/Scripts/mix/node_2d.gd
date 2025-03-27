extends Node2D  # 或者 extends Control，如果是 UI 控件

# 定义矩阵的大小和随机数串的大小
const ROWS = 10
const COLS = 10
const RANDOM_STR_LENGTH = 6
const MAX_ERRORS = 3  # 最大错误次数

# 存储数字矩阵的二维数组
var matrix = []

# 存储按钮的数组
var buttons = []

# 存储随机数串的数组
var random_string = []

# 记录当前需要点击的随机数串索引
var current_index = 0

# 记录错误次数
var error_count = 0

# 游戏初始化
func _ready():
	# 初始化矩阵数据并生成随机数
	matrix = []
	for i in range(ROWS):
		var row = []
		for j in range(COLS):
			row.append(randf_range(0, 100))  # 生成0-99之间的随机数
		matrix.append(row)

	# 初始化随机数串
	random_string = []
	for i in range(RANDOM_STR_LENGTH):
		random_string.append(randi_range(1, 10))  # 生成1到10之间的随机数

	# 创建 GridContainer 并配置
	var grid = GridContainer.new()
	grid.columns = COLS
	add_child(grid)

	# 创建每个按钮并添加到 GridContainer
	for i in range(ROWS):
		for j in range(COLS):
			var button = Button.new()
			button.text = str(matrix[i][j])  # 设置按钮上的文本为矩阵中的数字
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(i, j))  # 正确的信号连接方式
			grid.add_child(button)
			buttons.append(button)

	# 创建一个 Panel 用作容器，控制 Label 的大小
	var panel = Panel.new()
	panel.rect_min_size = Vector2(400, 40)  # 设置容器的最小尺寸
	add_child(panel)

	# 创建一个 Label 显示矩阵
	var random_str_label = Label.new()
	random_str_label.text = "随机数串: " + str(random_string)
	panel.add_child(random_str_label)  # 将 Label 放到 Panel 中
	random_str_label.rect_position = Vector2(0, 0)  # 将 Label 放置在容器内的左上角

	# 根据随机数串的规则替换矩阵中的数字
	replace_matrix_with_random_string()

# 替换矩阵中的数字
func replace_matrix_with_random_string():
	var index = 0
	for i in range(RANDOM_STR_LENGTH):
		var random_number = random_string[i]
		print("替换矩阵位置: " + str(i) + " 为随机数串上的数字: " + str(random_number))

		if i % 2 == 0:
			# 当 i 是偶数时，用随机数串的数字替换矩阵的某一行
			var row = i / 2
			if row < ROWS:
				for j in range(COLS):
					matrix[row][j] = random_number
					buttons[row * COLS + j].text = str(random_number)  # 更新按钮上的文本
		else:
			# 当 i 是奇数时，用随机数串的数字替换矩阵的某一列
			var col = i / 2
			if col < COLS:
				for j in range(ROWS):
					matrix[j][col] = random_number
					buttons[j * COLS + col].text = str(random_number)  # 更新按钮上的文本

# 按钮点击事件
func _on_button_pressed(row, col):
	# 获取当前矩阵上的数字
	var clicked_value = matrix[row][col]
	var target_value = random_string[current_index]
	
	print("你点击了位置 (" + str(row) + ", " + str(col) + "), 当前值: " + str(clicked_value) + ", 目标值: " + str(target_value))

	# 标记点击的行列，变色
	mark_row_and_col(row, col)

	# 判断玩家是否点击了正确的数字
	if clicked_value == target_value:
		print("点击正确！")
		# 你可以在这里给玩家一些反馈，比如改变按钮颜色
		buttons[row * COLS + col].disabled = true  # 禁用已点击的按钮
		current_index += 1  # 增加索引，指向下一个目标数字

		# 如果玩家已经点击完所有的数字
		if current_index == RANDOM_STR_LENGTH:
			print("游戏完成！")
			show_game_over("恭喜！你完成了游戏！")
			return
	else:
		# 如果玩家点击错误，增加错误计数
		error_count += 1
		print("点击错误！错误次数: " + str(error_count))

		# 如果错误次数达到最大限制，游戏失败
		if error_count >= MAX_ERRORS:
			print("错误次数达到限制，游戏失败！")
			show_game_over("游戏失败！")
			return

# 标记点击数字所在的行列，变色
func mark_row_and_col(row, col):
	# 标记该行
	for j in range(COLS):
		buttons[row * COLS + j].modulate = Color(1, 0, 0)  # 红色标记整行

	# 标记该列
	for i in range(ROWS):
		buttons[i * COLS + col].modulate = Color(0, 0, 1)  # 蓝色标记整列

# 显示游戏结束的提示
func show_game_over(message: String):
	# 禁用所有按钮
	for button in buttons:
		button.disabled = true

	# 显示游戏结束消息
	var game_over_label = Label.new()
	game_over_label.text = message
	game_over_label.rect_min_size = Vector2(300, 30)  # 设置 Label 的最小尺寸
	game_over_label.rect_position = Vector2(100, ROWS * 40 + 50)
	add_child(game_over_label)
