extends BaseGUIView

@onready var command_input = $VBoxContainer/CommandInput
@onready var output_label = $VBoxContainer/ScrollContainer/OutputLabel
@onready var path_label = $VBoxContainer/PathLabel

@export var default_terminal_config : String = "res://files/filesystem.json"

var terminal_system = preload("res://Clash/Scripts/cmd/TerminalSystem.gd").new()

# 外部初始化接口
func setup_terminal(config_path: String = ""):
	var path = config_path if config_path else default_terminal_config
	if terminal_system.load_filesystem(path):
		output_label.text = "Terminal Initialized: %s\n\n" % path.get_file()
	else:
		output_label.text = "Failed to load: %s\n\n" % path

func _ready():
	terminal_system.clear_requested.connect(_on_clear_requested)
	setup_terminal()
	command_input.grab_focus()
	update_prompt()
	output_label.text = "Terminal v1.0\nType 'man' for help\n\n"

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
	path_label.text = "user@%s:%s$ " % [terminal_system.hostname, path_str]

func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0.1/safe-mode.tscn")
	
func _on_clear_requested():
	output_label.text = ""
	await get_tree().process_frame
	var scroll = output_label.get_parent() as ScrollContainer
	scroll.scroll_vertical = 0
