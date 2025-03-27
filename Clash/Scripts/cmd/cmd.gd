extends BaseGUIView

@onready var command_input = $VBoxContainer/CommandInput
@onready var output_label = $VBoxContainer/ScrollContainer/OutputLabel
@onready var path_label = $VBoxContainer/PathLabel

var terminal_system = preload("res://Clash/Scripts/cmd/TerminalSystem.gd").new()

func _ready():
	# 确保路径与项目实际结构匹配
	terminal_system.load_filesystem("res://files/filesystem.json")
	command_input.grab_focus()
	update_prompt()
	# 初始消息
	output_label.text = "Hacker Terminal v1.0\nType 'man' for help\n\n"

func _on_command_input_text_submitted(new_text):
	if new_text.strip_edges().is_empty():
		return
	
	# 执行命令
	var output = terminal_system.execute_command(new_text)
	
	# 更新输出
	output_label.text += "> " + new_text + "\n" + output + "\n\n"
	command_input.text = ""
	update_prompt()
	
	# 延迟滚动确保布局更新
	await get_tree().process_frame
	var scroll = output_label.get_parent() as ScrollContainer
	scroll.scroll_vertical = output_label.size.y + 1000  # 确保滚动到底

func update_prompt():
	var path_str = "/".join(terminal_system.current_path)
	if path_str.is_empty():
		path_str = "/"
	path_label.text = "user@hackeros:%s$ " % path_str

func _on_button_exit_pressed() -> void:
	queue_free()  # 关闭界面
