extends Control

@export var mail_ui : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_button_mailbox_pressed() -> void:
	switch_to_mail_ui()




func switch_to_mail_ui():  #按下M键
	
	var main_ui = get_tree().get_root().get_node("MAIN")
	if main_ui:
		# 如果 MainUI 存在，隐藏它
		main_ui.visible = false
	else:
		print("Error: MainUI node not found!")
		print(main_ui)

	# 实例化并添加 mail_ui 场景
	var mail_node = mail_ui.instantiate()
	get_tree().get_root().add_child(mail_node)
	
