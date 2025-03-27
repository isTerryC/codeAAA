# MailboxManager.gd
class_name MailboxManager

var mailboxes: Dictionary = {}  # Key: player_id, Value: Array of Messages

# 发送消息
func send_message(player_id: int, message: Message):
	if not mailboxes.has(player_id):
		mailboxes[player_id] = []
	mailboxes[player_id].append(message)

# 获取玩家的所有消息
func get_messages(player_id: int) -> Array:
	if mailboxes.has(player_id):
		return mailboxes[player_id]
	return []

# 删除特定消息
func delete_message(player_id: int, message_id: int):
	if mailboxes.has(player_id):
		var messages = mailboxes[player_id]
		for i in range(messages.size() - 1, -1, -1):
			if messages[i].id == message_id:
				messages.remove(i)
