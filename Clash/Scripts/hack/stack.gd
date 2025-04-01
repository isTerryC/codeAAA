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
	$RichTextLabel.text = "Enter your payload (%19$p to leak libc)\n"
	$LineEdit.grab_focus()  # 自动聚焦到输入框

	# 监听回车键（不需要按钮）
	$LineEdit.connect("text_submitted", Callable(self, "_on_LineEdit_text_submitted"))

# 当用户按下回车时触发
func _on_LineEdit_text_submitted(input_text):
	$LineEdit.text = ""  # 清空输入框
	
	match current_state:
		GameState.INPUT:
			if input_text == "%19$p":
				# 模拟泄露 libc 地址
				leaked_address = libc_base + 0x1234
				$RichTextLabel.text += "Leaked address: 0x%x\n" % leaked_address
				$RichTextLabel.text += "Now calculate system() and /bin/sh addresses!\n"
				current_state = GameState.WIN
			else:
				$RichTextLabel.text += "Invalid payload! Try %19$p\n"
		
		GameState.WIN:
			$RichTextLabel.text += "[color=green]> Challenge completed![/color]\n"


func _on_button_exit_pressed() -> void:
	pass # Replace with function body.
