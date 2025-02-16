extends Control

@onready var message_container = $VBoxContainer
@onready var message_content_label = $MessageContent
@onready var close_button = $CloseButton

var mailbox_manager: MailboxManager

func _ready():
	# 初始化 MailboxManager
	mailbox_manager = preload("res://addons/dialogic/Resources/MailboxManager.gd").new()

	# 绑定关闭按钮事件
	if close_button:
		close_button.connect("pressed", self._on_close_button_pressed)
	else:
		print("Error: CloseButton is null!")

	# 加载消息
	load_messages(1)  # 假设加载玩家 1 的消息

# 加载消息并显示
func load_messages(player_id: int):
	if message_container:
		# 清空现有消息
		for child in message_container.get_children():
			child.queue_free()

		# 获取消息列表
		var messages = mailbox_manager.get_messages(player_id)
		for msg in messages:
			var button = Button.new()
			button.text = "From: %s" % msg.sender
			button.rect_min_size = Vector2(200, 50)  # 设置按钮大小
			button.connect("pressed", self._on_message_selected.bind(msg))
			message_container.add_child(button)
	else:
		print("Error: message_container is null!")

# 当消息被选中时显示内容
func _on_message_selected(message: Message):
	if message_content_label:
		message_content_label.text = "From: %s\n\n%s" % [message.sender, message.content]
	else:
		print("Error: message_content_label is null!")

# 关闭信箱
func _on_close_button_pressed():
	queue_free()
