extends Control

# 模拟的 libc 基地址和偏移
var libc_base = 0x7ffff7a00000
var libc_system_offset = 0x055410
var libc_binsh_offset = 0x1b75aa

# 泄露的地址和计算后的地址
var leaked_address = 0
var system_address = 0
var binsh_address = 0

# 游戏状态
enum GameState { INPUT, WIN }
var current_state = GameState.INPUT

func _ready():
	# 初始化 UI
	$RichTextLabel.bbcode_enabled = true
	$RichTextLabel.text = ""
	$LineEdit.grab_focus()
	$LineEdit.connect("text_submitted", Callable(self, "_on_LineEdit_text_submitted"))
	await show_guided_messages([
		"好了，现在应该发过去了。",
		"左边是我搜集的源代码，一个简单的fmt漏洞",
		"真不知道设计者怎么想的，输入了姓名还要返回显示一遍",
		"不管怎么说，输入%49$p，你的任务就完成了。",
		"我远程没办法泄露你连接的libc",
		"这步实际上就是在泄露你的_libc_start_main的地址"
	], 1.0)

# 文本提交处理
func _on_LineEdit_text_submitted(input_text):
	$LineEdit.text = ""
	
	match current_state:
		GameState.INPUT:
			if input_text == "%49$p":
				start_leak_sequence()
			else:
				show_error()

# 开始泄露流程
func start_leak_sequence():
	# 禁用输入
	$LineEdit.editable = false
	
	# 立即显示泄露信息
	leaked_address = libc_base + 0x1234
	append_message("[color=yellow]Leaked address: 0x%x[/color]" % leaked_address)
	
	# 延时显示后续提示
	await show_guided_messages([
		"Analyzing memory layout...",
		"Calculating libc base address...",
		"[color=yellow]Hint: system @ 0x%x[/color]" % (libc_base + libc_system_offset),
		"[color=yellow]Hint: /bin/sh @ 0x%x[/color]" % (libc_base + libc_binsh_offset),
		"Now build your ROP chain!",
		"哦，那是我原本的代码，不必在意。"
	], 1.0)
	
	await show_guided_messages([
		"稍等片刻",
		"好了"
	], 2.0)
	
	if(G.flag<5):
		G.update_flag(5)
		G.set_scannable_temporary()
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0.1/safe-mode-message.tscn")

# 分步显示引导信息
func show_guided_messages(messages: Array, interval: float) -> void:
	for msg in messages:
		await get_tree().create_timer(interval).timeout
		append_message(msg)

# 添加带自动滚动的消息
func append_message(text: String) -> void:
	$RichTextLabel.append_text(text + "\n")
	# 滚动到底部
	await get_tree().process_frame
	$RichTextLabel.scroll_to_line($RichTextLabel.get_line_count() - 1)

# 显示错误信息
func show_error():
	append_message("[color=red]Invalid payload! Try %49$p[/color]")

func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/cmd/cmd.tscn")
