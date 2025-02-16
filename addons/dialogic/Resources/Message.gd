# Message.gd
class_name Message

var id: int
var content: String
var sender: String

func _init(p_id: int, p_content: String, p_sender: String):
	id = p_id
	content = p_content
	sender = p_sender
