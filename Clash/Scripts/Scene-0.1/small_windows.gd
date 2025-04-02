extends Panel

@onready var message_label: Label = $MessageLabel

func _ready():
	# 初始状态设置
	scale = Vector2(0.5, 0.5)
	modulate.a = 0
	visible = false
	pivot_offset = size / 2
	
	# 自动开始弹出流程
	await get_tree().create_timer(0.1).timeout  # 等待一帧确保初始化完成

# 显示弹窗
func show_popup(text: String = "", display_time: float = 2.0):
	if message_label and text != "":
		message_label.text = text
	
	visible = true
	
	# 弹出动画
	var pop_tween = create_tween()
	pop_tween.tween_property(self, "scale", Vector2(1, 1), 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	pop_tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2)
	
	# 自动缩回
	await get_tree().create_timer(display_time).timeout
	hide_popup()

# 隐藏弹窗
func hide_popup():
	var hide_tween = create_tween()
	hide_tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
	hide_tween.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
	
	await hide_tween.finished
	visible = false
	queue_free()
