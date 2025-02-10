extends Control

# 定义矩阵的大小和随机数串的大小
const ROWS = 10
const COLS = 10
const RANDOM_STR_LENGTH = 8
const MAX_ERRORS = 3  # 最大错误次数
const BUTTON_SIZE = 50  # 调整按钮大小为 50，按钮更小一点
const FONT_SIZE = 30  # 设置数字字体大小
const RANDOM_STR_FONT_SIZE = 30  # 设置随机数串的字体大小
const GAME_TIP_FONT_SIZE = 20  # 设置游戏提示的字体大小

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

# 存储每个按钮原始的颜色
var original_colors = []

# 存储游戏提示的 Label
var game_tip_label = null

# 记录前一个替换位置
var last_replacement_position = null

# 存储字体
var custom_font : Font = null

# 游戏初始化
func _ready():
	# 加载自定义字体文件，确保路径正确
	custom_font = load("res://fonts/Roboto_SemiCondensed-ExtraBoldItalic.ttf")  # 使用 FontFile 类型来加载字体
	if custom_font:
		print("字体加载成功！")
	else:
		print("字体加载失败！")  # 如果字体加载失败，打印错误信息

	# 初始化矩阵数据并生成随机数
	initialize_matrix_with_unique_numbers()

	# 初始化随机数串
	random_string = []
	for i in range(RANDOM_STR_LENGTH):
		random_string.append(randi_range(1, 10))  # 生成1到10之间的随机整数

	# 创建 GridContainer 并配置
	var grid = GridContainer.new()
	grid.columns = COLS
	add_child(grid)

	# 创建每个按钮并添加到 GridContainer
	for i in range(ROWS):
		for j in range(COLS):
			var button = Button.new()
			button.text = str(matrix[i][j])  # 设置按钮上的文本为矩阵中的数字
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(i, j))  # 使用正确的绑定方式
			button.custom_minimum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)  # 设置按钮的最小尺寸为 50
			button.add_theme_font_override("font", custom_font)  # 设置按钮字体
			button.add_theme_font_size_override("font_size", FONT_SIZE)  # 设置按钮字体大小
			grid.add_child(button)
			buttons.append(button)

			# 保存按钮的原始颜色
			original_colors.append(button.modulate)

	# 创建一个 Label 显示矩阵
	var random_str_label = Label.new()
	random_str_label.text = "随机数串: " + str(random_string)
	random_str_label.position = Vector2(0, ROWS * BUTTON_SIZE + 50)  # 将其放在矩阵下方，向下移动50单位
	random_str_label.custom_minimum_size = Vector2(600, 40)  # 使用 custom_minimum_size 设置最小尺寸
	random_str_label.add_theme_font_override("font", custom_font)  # 使用自定义字体
	random_str_label.add_theme_font_size_override("font_size", RANDOM_STR_FONT_SIZE)  # 设置随机数串的字体大小
	add_child(random_str_label)

	# 创建游戏提示标签，放在矩阵右侧
	game_tip_label = Label.new()
	game_tip_label.text = "游戏开始！点击数字。\n规则：从第一个数开始，然后随机数串下一个数在该行寻\n找并点击，下一个数在上一个数的所在列寻找并点击，\n下一个再次变为行内寻找，如此往复。"
	game_tip_label.position = Vector2(COLS * BUTTON_SIZE + 40, 0)  # 将提示放在矩阵右侧
	game_tip_label.custom_minimum_size = Vector2(300, 40)  # 设置提示的宽度
	game_tip_label.add_theme_font_override("font", custom_font)  # 使用自定义字体
	game_tip_label.add_theme_font_size_override("font_size", GAME_TIP_FONT_SIZE)  # 设置游戏提示的字体大小
	add_child(game_tip_label)

	# 根据随机数串的规则替换随机数串中的数字
	replace_random_string_with_matrix()

	# 更新显示的数字串
	random_str_label.text = "随机数串: " + str(random_string)

# 初始化矩阵，确保所有数字唯一
func initialize_matrix_with_unique_numbers():
	var total_numbers = ROWS * COLS
	var unique_numbers = []

	# 生成一个包含 0 到 99 的所有数字的列表
	for i in range(100):
		unique_numbers.append(i)

	# 打乱列表
	unique_numbers.shuffle()

	# 将打乱后的数字填充到矩阵中
	matrix = []
	for i in range(ROWS):
		var row = []
		for j in range(COLS):
			row.append(unique_numbers[i * COLS + j])
		matrix.append(row)

# 替换随机数串中的数字
func replace_random_string_with_matrix():
	var row = 0  # 从第一行开始
	var col = 0  # 从第一列开始
	for i in range(RANDOM_STR_LENGTH):
		var random_number = random_string[i]
		print("替换随机数串上的数字: " + str(random_number) + " 为矩阵中的数字: " + str(matrix[row][col]))

		# 检查是否是连续替换同一个位置
		if last_replacement_position == Vector2(row, col):
			# 如果连续替换同一个位置，修改数字的位置
			if i%2!=0:
				if col < COLS - 1:
					col += 1  # 改为当前列的下一个位置
				else:
					col = 0  # 如果已经是最后一列，跳回第一列
			else:
				if row < ROWS - 1:
					row +=1
				else:
					row = 0
			# 更新替换位置
			last_replacement_position = Vector2(row, col)
		else:
			# 更新替换位置
			last_replacement_position = Vector2(row, col)

		# 将随机数串中的数字替换为矩阵对应位置的数字
		random_string[i] = matrix[row][col]  # 更新随机数串中的值为矩阵的值

		if i % 2 == 0:
			# 如果是偶数：更新到该行的随机数串上的数的对应列
			col = randi_range(0, COLS - 1)  # 选择随机列
		else:
			# 如果是奇数：更新到该列的随机数串上的数的对应行
			row = randi_range(0, ROWS - 1)  # 选择随机行

	print("替换后的随机数串: " + str(random_string))

# 按钮点击事件
func _on_button_pressed(row, col):
	# 获取当前矩阵上的数字
	var clicked_value = matrix[row][col]
	var target_value = random_string[current_index]
	
	print("你点击了位置 (" + str(row) + ", " + str(col) + "), 当前值: " + str(clicked_value) + ", 目标值: " + str(target_value))

	# 恢复之前标记的行列颜色
	reset_marked_row_and_col()

	# 标记点击的行列，变色
	mark_row_and_col(row, col)

	# 判断玩家是否点击了正确的数字
	if clicked_value == target_value:
		print("点击正确！")
		# 提示玩家当前目标正确
		update_game_tip("点击正确！你已点击第 " + str(current_index + 1) + " 个数字，目标是 " + str(target_value))
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

# 更新游戏提示
func update_game_tip(message: String):
	if game_tip_label:
		game_tip_label.text = message  # 更新提示内容

# 标记点击数字所在的行列，变色
func mark_row_and_col(row, col):
	# 标记该行，颜色为红色
	for j in range(COLS):
		buttons[row * COLS + j].modulate = Color(1, 0, 0)  # 红色标记整行

	# 标记该列，颜色为红色
	for i in range(ROWS):
		buttons[i * COLS + col].modulate = Color(1, 0, 0)  # 红色标记整列

# 恢复行列的颜色
func reset_marked_row_and_col():
	for i in range(ROWS):
		for j in range(COLS):
			buttons[i * COLS + j].modulate = original_colors[i * COLS + j]  # 恢复颜色

# 显示游戏结束的提示
func show_game_over(message: String):
	# 禁用所有按钮
	for button in buttons:
		button.disabled = true

	# 显示游戏结束消息
	var game_over_label = Label.new()
	game_over_label.text = message
	game_over_label.position = Vector2(100, ROWS * BUTTON_SIZE + 90)
	game_over_label.custom_minimum_size = Vector2(300, 40)
	game_over_label.add_theme_font_override("font", custom_font)  # 使用自定义字体
	game_over_label.add_theme_font_size_override("font_size", GAME_TIP_FONT_SIZE)  # 设置结束提示字体大小
	add_child(game_over_label)
